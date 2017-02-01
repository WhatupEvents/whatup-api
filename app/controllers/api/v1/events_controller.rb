class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    distance = params[:distance] || 10.0
    render json: current_user.current_events | Event.pub.current.near_user(current_user, distance),
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

    before_update = event.participant_relationships.all.map(&:attributes)
    if create_event_params[:friend_ids]
      friend_ids = JSON.parse(create_event_params[:friend_ids])
      participants = User.where(id: friend_ids + [create_event_params[:created_by_id]])
      event.participants = participants
      params.delete("friend_ids")
    end
    after_update = event.participant_relationships.all.map(&:attributes)

    event.update_attributes! create_event_params

    if Rails.env != "development"
      (before_update+after_update).uniq.each do |participant|
        if participant['notify'] && (participant['participant_id'] != current_user.id)
          Resque.enqueue(
            FcmMessageJob, {
              event_id: event.id,
              event_name: event.name,
              updated_at: event.updated_at
            },participant['participant_id']
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
    Event.find(params[:id]).destroy
    render json: {},
           status: :ok
  end

  def leave
    event = Event.find(params[:id])
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

  private

  def create_event_params
    params.except(:format, :id).permit(event_param_keys)
  end
  
  def event_param_keys
    [:name, :details, :created_by_id, :start_time, :end_at, :symbol_id, :category_id,
     :location, :latitude, :longitude, :public, :source, :image, :friend_ids]
  end
end
