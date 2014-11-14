module Api
  module V1
    class StatusesController < ApiController
      doorkeeper_for :all

      def create
        Status.create! status_params
        head :created
      rescue
        head :bad_request
      end

      def status_params
        params.require(:status).permit(:user_id, :symbol_id, :text)
      end
    end
  end
end
