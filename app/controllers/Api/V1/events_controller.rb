module Api
  module V1
    class EventsController < ApiController
      doorkeeper_for :all

      def index
        user = User.find(event_params[:friend_id])
        events = user.events 

        if events.present?
          render json: events,
                 each_serializer: Api::V1::EventSerializer,
                 status: :ok
        else
          head :not_found
        end
      rescue Exception => e
        head :bad_request
      end

      def event_params
        params.require(:event).permit(:my_id, :friend_id)
      end
    end
  end
end
