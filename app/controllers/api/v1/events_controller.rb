class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    distance = params[:distance] || 10.0
    events = current_user.current_events
    if get_geo
      long, lat = get_geo.split(':')
      events |= Event.pub.current.near_user(lat, long, distance)
      # eventually need to either remove this or do a by city thing to limit
      # events that don't have coordinates at least by city and not lose them
      events |= Event.pub.current.where(latitude: '200.0', longitude: '200.0')
    end
    render json: events,
           each_serializer: Api::V1::EventSerializer,
           status: :ok,
           current_user: current_user.id
  end

  def create
    event = Event.create! create_event_params

    event.participants = [current_user]
    render json: event,
           serializer: Api::V1::EventSerializer,
           status: :created,
           current_user: current_user.id
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def update
    event = Event.find(params[:id])
    
    if (event.created_by_id != current_user.id && current_user.role != 'Admin') ||
      (create_event_params[:public] == '1' && current_user.role == 'User')
      head :bad_request
    else

      # if event is being made public send out notifications
      if (event.created_by.followers.count > 0 && create_event_params[:public] == '1' \
        && Rails.env != "development")
        event.created_by.followers.each do |follower|
          Resque.enqueue(
            FcmMessageJob, {
              followed_name: current_user.name,
              created_at: event.created_at
            }, follower.id
          )
        end
      end

      # clear participants when going from private to public or viceversa
      if event.public != (create_event_params[:public] == "true")
        event.participants = []
        params.delete("friend_ids")
      end

      # saves participants before change so that they can be notified
      # when they've been removed from an event?
      before_update = event.participant_relationships.all.map(&:attributes)

      if create_event_params[:friend_ids]
        friend_ids = JSON.parse(create_event_params[:friend_ids])
        participants = User.where(id: friend_ids + [create_event_params[:created_by_id]])
        event.participants = participants
        params.delete("friend_ids")
      end

      after_update = event.participant_relationships.all.map(&:attributes)

      # update attributes
      event.update_attributes! create_event_params

      # messages go out to participants that have notifications on
      if Rails.env != "development"
        (before_update+after_update).uniq.each do |participant|
          if participant['notify'] && (participant['participant_id'] != current_user.id)
            Resque.enqueue(
              FcmMessageJob, {
                event_id: event.id,
                event_name: event.name,
                updated_at: event.updated_at
              }, participant['participant_id']
            )
          end
        end
      end

      render json: event,
             serializer: Api::V1::EventSerializer,
             status: :ok,
             current_user: current_user.id
    end

  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def destroy
    event = Event.find(params[:id])
    
    if event.created_by_id == current_user.id || current_user.role == 'Admin'
      event.destroy
      render json: {},
             status: :ok
    else
      head :bad_request
    end
  end

  def rsvp
    event = Event.find(params[:event_id])
    event.participants |= [current_user]
    render json: {},
           status: :ok
  end

  def leave
    event = Event.find(params[:event_id])
    event.participants.delete current_user
    render json: {},
           status: :ok
  end

  def notify
    event = Event.find(params[:event_id])
    participant_relationship = event.participant_relationships.select{|p| p.participant_id == current_user.id}[0]
    participant_relationship.update_attribute('notify', !participant_relationship.notify)
    render json: {},
           status: :ok
  end

  def follow_creator
    event = Event.find(params[:event_id])
    event_creator = event.created_by

    already_following = event_creator.followers.include? current_user
    json_result = {
      creator_name: event_creator.name,
      followed: !already_following
    }

    if already_following 
      event_creator.followers = event_creator.followers - [current_user]
    else
      event_creator.followers |= [current_user]
    end

    render json: json_result,
           status: :ok
  end

  private

  def create_event_params
    params.except(:format, :id).permit(event_param_keys)
  end
  
  def event_param_keys
    [:name, :details, :created_by_id, :start_time, :end_at, :symbol_id, :category_id,
     :location, :latitude, :longitude, :public, :source, :image, :friend_ids]
  end
end
