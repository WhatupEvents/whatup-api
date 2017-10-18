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
       status: :ok,
       current_user: current_user.id
  end

  def destroy
    Shout.find(params[:id]).destroy
    render json: {},
           status: :ok
  end

  def flag
    @shout = Shout.find(params[:shout_id])
    unless @shout.flagged_by.include? current_user
      Flag.create(user_id: current_user.id, obj_class: 'Shout', obj_id: @shout.id)
      flag_update = 1
      if current_user.role == "Admin"
        flag_update = 3
      end
      @shout.update_attributes flag: @shout.flag+flag_update
      @shout.flagged_by << current_user
    end
    render json: @shout,
       serializer: Api::V1::ShoutSerializer,
       status: :ok,
       current_user: current_user.id
  end
  
  def block
    @shout = Shout.find(params[:shout_id])
    Flag.find_or_create_by(user_id: current_user.id, obj_class: 'User', obj_id: @shout.user_id)
    head :ok
  end

  def up
    @shout = Shout.find(params[:shout_id])
    unless @shout.upped_by.include? current_user
      @shout.update_attributes ups: @shout.ups+1
      @shout.upped_by << current_user
    end
    render json: @shout,
       serializer: Api::V1::ShoutSerializer,
       status: :ok,
       current_user: current_user.id
  end

  private

  def update_image
    unless @shout.image.url.include? "missing.png"
      obj = Aws::S3::Object.new(
        bucket_name: 'whatupevents-images',
        key: @shout.image.url.split('whatupevents-images/')[1].split('?')[0],
        access_key_id: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY'],
        region: 'us-east-2'
      )
      @shout.update_attribute(:url, obj.presigned_url(:get, expires_in: 60*60*7))
    end
  end

  def render_shouts
    last = params.has_key?(:last_id) ? Shout.find(params.delete(:last_id)) : Shout.last
    long, lat = get_geo.split(':')

    in_range_event_ids = Event.current.pub.near_user(lat, long, 20.0).map(&:id)
    invalid_event_ids = Flag.where(obj_class: "Event", obj_id: in_range_event_ids, user_id: current_user.id).map(&:obj_id)
    invalid_user_ids = Flag.where(obj_class: "User", user_id: current_user.id).map(&:obj_id)

    shouts = Shout.where('created_at > ?', Time.now-7.hour)
      .where('created_at <= ?', last.created_at)
      .where('flag < 8')
      .where('user_id NOT IN (?)', invalid_user_ids.present? ? invalid_user_ids : '')
      .where(event_id: in_range_event_ids)
      .where('event_id NOT IN (?)', invalid_event_ids.present? ? invalid_event_ids : '')
      .limit(15).order(created_at: :desc).not_flagged_for(current_user.id)

    tutorial_shouts = Shout.where(event_id: Event.where(latitude: 200, longitude: 200))
      .where('event_id NOT IN (?)', invalid_event_ids.present? ? invalid_event_ids : '')

    shouts = tutorial_shouts + shouts
    if shouts.present?
      render json: shouts,
             each_serializer: Api::V1::ShoutSerializer,
             status: :ok,
             current_user: current_user.id
    else
      render json: {}, status: :not_found
    end
  end

  def shout_params
    params.except(:format, :id).permit(:user_id, :text, :source, :image, :event_id, :last_id, :ups, :flag)
  end
end
