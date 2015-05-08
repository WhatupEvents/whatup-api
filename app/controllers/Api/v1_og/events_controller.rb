class Api::V1::EventsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render json: current_user.events,
           each_serializer: Api::V1::EventSerializer,
           status: :ok
  end

  def create
    event = Event.create! event_params
    current_user.events << event
    render json: event,
           serializer: Api::V1::EventSerializer,
           status: :created
  rescue
    head :bad_request
  end

  def destroy
    Event.find(params[:id]).destroy
    head :ok
  rescue
    head :bad_resquest
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :symbol_id, :start_time, :address, :public, :created_by_id)
  end
end
