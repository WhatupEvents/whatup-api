class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def mine
    events = current_user.events
    events |= current_user.organizations.reject{|o| o.id == 1}.map(&:events).flatten

    Rails.logger.info events.map(&:id)
    render json: events.sort{|x,y| x.start_time.to_i <=> y.start_time.to_i},
           each_serializer: Api::V1::EventSerializer,
           status: :ok,
           current_user: current_user.id
  end

  def index
    distance = params[:distance] || 10.0
    events = current_user.current_events

    if get_geo
      long, lat = get_geo.split(':')

      public_events = Event.current.near_user(lat, long, distance).pub
        .not_flagged_for(current_user.id)

      if current_user.id == 95
        public_events = Event.jon_current.near_user(lat, long, distance).pub
          .not_flagged_for(current_user.id)
      end

      events |= public_events
    end

    events.sort!{|x,y| x.start_time <=> y.start_time}
      
    # this adds top of the list events, at the moment we don't want tutorial
    # I think this can go away because I pull shouts by this same query too
    events |= Event.where("latitude = '200.0' AND longitude = '200.0' AND name != 'tutorial'")

    render json: events,
           each_serializer: Api::V1::EventSerializer,
           status: :ok,
           current_user: current_user.id
  end

  def create
    if current_user.role == 'Unverified'
      head :forbidden
      return
    end

    event = Event.create! event_params
    if event.created_by_type.nil?
      event.update_attributes(created_by_type: 'User')
    end
    event.participants = [current_user]

    notify_followers(event) if event.public

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

    creator_ids = [event.created_by_id]
    if event.created_by_type == "Organization"
      # if event is from an organization, need to look at creating organization members
      creator_ids = event.created_by.members.map(&:id)
    end

    # Only the event creator or Admins can update events
    # Regular users cannot make events public
    if (!creator_ids.include?(current_user.id) && current_user.role != 'Admin') ||
      (event_params[:public] == 'true' && (current_user.role == 'User' || current_user.role == 'Unverified'))
      head :forbidden
      return
    end

    # saves participants before change so that they can be notified
    # when they've been removed from an event?
    before_update = event.participant_relationships.all.map(&:attributes)

    if event.public != (event_params[:public] == "true")
      # clear participants when going from private to public or viceversa
      event.participants = []
    else
      if event_params[:friend_ids] && !event.public
        # only update friend_ids through event update when event is private
        friend_ids = JSON.parse(event_params[:friend_ids])
        event.participants = User.where(id: friend_ids + [current_user.id])
      end
    end
    params.delete("friend_ids")

    after_update = event.participant_relationships.all.map(&:attributes)

    # update attributes
    event.update_attributes! event_params

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

  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def destroy
    event = Event.find(params[:id])
    
    creator_ids = [event.created_by_id]
    if event.created_by_type == "Organization"
      creator_ids = Organization.find(event.created_by_id).members.map(&:id)
    end

    # messages go out to participants that have notifications on
    if Rails.env != "development"
      event.participants.uniq.each do |participant|
        if participant.id != current_user.id
          Resque.enqueue(
            FcmMessageJob, {
              event_id: event.id,
              event_name: event.name,
              deleted_at: Time.now
            }, participant.id
          )
        end
      end
    end

    if creator_ids.include?(current_user.id) || current_user.role == 'Admin'
      event.destroy
      render json: {},
             status: :ok
    else
      head :forbidden
    end
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

    if event.created_by_type == "Organization"
      creator = event.created_by
    else
      # can get rid of this or add a bad request if getting a follow from non org event?
      creator = event.created_by.organizations.first
    end

    already_following = creator.followers.include? current_user
    json_result = {
      creator_name: event.created_by.name,
      followed: !already_following
    }

    if already_following 
      creator.followers = creator.followers - [current_user]
    else
      creator.followers |= [current_user]
    end

    render json: json_result,
           status: :ok
  end

  def rsvp
    event = Event.find(params[:event_id])
    json = {}

    if event.participants.include? current_user
      event.participants = event.participants - [current_user]
      json[:action] = 'un-rsvp'
    else
      event.participants |= [current_user]
      json[:action] = 'rsvp'
    end
    render json: json,
           status: :ok
  end

  def check_action
    event = Event.find(params[:event_id])

    if event.created_by_type == "Organization"
      creator = event.created_by
    else
      # can get rid of this or add a bad request if getting a follow from non org event?
      creator = event.created_by.organizations.first
    end

    participant_relationship = event.participant_relationships.select{|p| p.participant_id == current_user.id}[0]
    json = {
      rsvp: event.participants.include?(current_user).to_s,
      follow: creator ? creator.followers.include?(current_user).to_s : '',
      notify: participant_relationship ? participant_relationship.notify.to_s : ''
    }

    render json: json,
           status: :ok
  end

  private

  def notify_followers(event)
    creator = event.created_by

    if (Rails.env != "development" && creator && creator.followers.count > 0)
      creator.followers.each do |follower|
        Resque.enqueue(
          FcmMessageJob, {
            followed_name: event.created_by.name,
            event_name: event.name,
            created_at: event.created_at
          }, follower.id
        )
      end
    end
  end

  def event_params
    params.except(:format, :id).permit(event_param_keys)
  end
  
  def event_param_keys
    [:name, :details, :created_by_id, :created_by_type, :start_time, :end_at, :symbol_id, :category_id,
     :location, :latitude, :longitude, :public, :source, :image, :friend_ids]
  end
end
