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

  def update
    shout = Shout.find(params[:id])
    shout.update_attributes! shout_params
    render json: shout,
           serializer: Api::V1::ShoutSerializer,
           status: :ok
  end

  private

  def render_shouts
    last = params.has_key?(:last_id) ? Shout.find(params.delete(:last_id)) : Shout.last
    shouts = Shout.where('created_at > ?', Time.now-7.hour)
      .where(event_id: Event.current.pub.near_user(current_user, 2.0).map(&:id))
      .where('created_at < ?', last.created_at)
      .limit(15).order(created_at: :desc)
    if shouts.present?
      render json: shouts,
             each_serializer: Api::V1::ShoutSerializer,
             status: :ok
    else
      head :not_found
    end
  end

  def shout_params
    params.except(:format, :id).permit(:user_id, :text, :source, :image, :event_id, :last_id)
  end
end
