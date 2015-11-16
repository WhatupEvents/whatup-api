class Api::V1::ShoutsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render_shouts
  end

  def create
    Shout.create! shout_params
    render_shouts
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  private

  def render_shouts
    shouts = Shout.where('created_at > ?', Date.today-1.day)
    if shouts.present?
      render json: shouts.reverse,
             each_serializer: Api::V1::ShoutSerializer,
             status: :ok
    else
      head :not_found
    end
  end

  def shout_params
    params.require(:shouts).permit(:user_id, :text)
  end
end
