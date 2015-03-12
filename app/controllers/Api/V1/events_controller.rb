module Api
  module V1
    class EventsController < ApiController
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

      def event_params
        params.require(:event).permit(:name, :description, :symbol_id, :start_time, :address, :public)
      end
    end
  end
end
