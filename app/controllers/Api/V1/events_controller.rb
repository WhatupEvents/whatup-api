module Api
  module V1
    class EventsController < ApiController
      doorkeeper_for :all

      def index
        render json: current_user.events,
               each_serializer: Api::V1::EventSerializer,
               status: :ok
      end
    end
  end
end
