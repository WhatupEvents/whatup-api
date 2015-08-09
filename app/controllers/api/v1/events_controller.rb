class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: current_user.current_events,
           each_serializer: Api::V1::EventSerializer,
           status: :ok
  end

  def create
    # need to pass participant ids to add them to event
    event = Event.create! event_params
    current_user.events << event
    render json: event,
           serializer: Api::V1::EventSerializer,
           status: :created
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def update
    event = Event.find(params[:id])

    if event_params[:friend_ids]
      friend_ids = JSON.parse(event_params[:friend_ids])
      if friend_ids
        params[:event].delete(:friend_ids)
        participants = User.where('id in (?)', friend_ids)
        if participants.empty?
          event.participants = []
        else
          event.participants |= participants
        end
      end
    end

    event.update_attributes!(event_params)
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

  private

  def event_params
    params.require(:event).permit(
      :name,
      :details,
      :symbol_id,
      :start_time,
      :location,
      :public,
      :created_by_id,
      :category_id,
      :friend_ids
    )
  end
end
