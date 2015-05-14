class Api::V1::StatusesController < Api::V1::ApiController
  doorkeeper_for :all

  def create
    Status.create! status_params
    head :created
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def status_params
    params.require(:status).permit(:user_id, :symbol_id, :text)
  end
end
