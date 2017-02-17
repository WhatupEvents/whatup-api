class Api::V1::ShoutsController < Api::V1::ApiController
  doorkeeper_for :all

  def index
    render_shouts
  end

  def create
    @shout = Shout.create! shout_params
    update_image
    render_shouts
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def update
    @shout = Shout.find(params[:id])
    @shout.update_attributes! shout_params
    update_image
    render json: @shout,
       serializer: Api::V1::ShoutSerializer,
       status: :ok
  end

  def flag
    @shout = Shout.find(params[:shout_id])
    # TODO: if admin flag up to 3 automatically
    flag_update = 1
    if current_user.role == "Admin"
      flag_update = 3
    end
    @shout.update_attributes flag: @shout.flag+flag_update
    render json: @shout,
       serializer: Api::V1::ShoutSerializer,
       status: :ok
  end

  def up
    @shout = Shout.find(params[:shout_id])
    @shout.update_attributes ups: @shout.ups+1
    render json: @shout,
       serializer: Api::V1::ShoutSerializer,
       status: :ok
  end

  private

  def update_image
    unless @shout.image.url.include? "missing.png"
      obj = Aws::S3::Object.new(
        bucket_name: 'whatupevents-images',
        key: @shout.image.url.split('whatupevents-images/')[1].split('?')[0],
        access_key_id: 'AKIAJSKGHQFVPEXZZGMA',
        secret_access_key: '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',
        region: 'us-east-2'
      )
      @shout.update_attribute(:url, obj.presigned_url(:get, expires_in: 60*60*7))
    end
  end

  def render_shouts
    last = params.has_key?(:last_id) ? Shout.find(params.delete(:last_id)) : Shout.last
    long, lat = get_geo.split(':')
    shouts = Shout.where('created_at > ?', Time.now-7.hour)
      .where(event_id: Event.current.pub.near_user(lat, long, 20.0).map(&:id))
      .where('created_at <= ?', last.created_at)
      .where('flag <= 3')
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
    params.except(:format, :id).permit(:user_id, :text, :source, :image, :event_id, :last_id, :ups, :flag)
  end
end
