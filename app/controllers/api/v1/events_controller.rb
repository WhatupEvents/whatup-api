class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    lat_to_feet = 400.0/362778.0
    long_to_feet = 400.0/365166.0
    public_events = Event.where(public: true)
      .where('latitude > ? AND latitude < ? ', 
             current_user.latitude.to_f*(1.0-lat_to_feet),
             current_user.latitude.to_f*(1.0+lat_to_feet))
      .where('longitude > ? AND longitude < ?',
             current_user.longitude.to_f*(1.0+long_to_feet),
             current_user.longitude.to_f*(1.0-long_to_feet)).all
      # need to account for hemispheres?
    render json: current_user.current_events | public_events,
           each_serializer: Api::V1::EventSerializer,
           status: :ok
  end

  def create
    event = Event.create! create_event_params
    event.participants = [current_user]
    render json: event,
           serializer: Api::V1::EventSerializer,
           status: :created
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def update
    event = Event.find(params[:id])

    if create_event_params[:friend_ids]
      friend_ids = JSON.parse(create_event_params[:friend_ids])
      participants = User.where(id: friend_ids + [create_event_params[:created_by_id]])
      event.participants |= participants
      params.delete("friend_ids")
    end

    event.update_attributes! create_event_params
    render json: event,
           serializer: Api::V1::EventSerializer,
           status: :ok
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
  private

  def create_event_params
    params.except(:format, :id).permit(event_param_keys)
  end
  
  def event_param_keys
    [:name, :details, :created_by_id, :start_time, :symbol_id, :category_id,
     :location, :latitude, :longitude, :public, :source, :image, :friend_ids]
  end
end
