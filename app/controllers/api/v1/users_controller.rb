class Api::V1::UsersController < Api::V1::ApiController
  doorkeeper_for :all, except: [:create, :authenticate]

  def create
    user_params['email'] = user_params['first_name'] + '@' + user_params['last_name'] if user_params['email'].empty?
    @current_user = User.find_or_initialize_by(email: user_params['email'])
    if @current_user.new_record?
      @current_user.update(user_params)
      @current_user.role = 'User'
      @current_user.save
      render_me :created
    else
      render_me :ok
    end
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def friends
    User.where('fb_id in (?)',JSON.parse(params['friends_fb_ids'])).each do |friend|
      FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: friend.id)
      FriendRelationship.find_or_create_by(person_id: friend.id, friend_id: current_user.id)
    end
    render json: current_user.friends,
           each_serializer: Api::V1::FriendSerializer,
           status: :ok
  end

  def fcm_register
    current_device = Device.where(uuid: device_params[:uuid], user_id: current_user.id)
    current_device.update_attributes(device_params.permit(:registration_id))
  end

  private

  def render_me(status)
    # Device.find_or_create_by({user_id: @current_user.id}.merge(device_params)} ??????
    device = Device.find_or_initialize_by(user_id: @current_user.id, uuid: device_params[:uuid])
    device.os = device_params[:os]
    device.registration_id = device_params[:registration_id]
    device.save

    render json: current_me,
           serializer: Api::V1::MeSerializer,
           status: status
  end

  def current_me
    Rails.logger.info @current_user.to_s
    Rails.logger.info process_access_token.to_s
    me = Api::V1::Me.new(@current_user, process_access_token)
    Rails.logger.info me.to_s
    return me
  end

  def device_params
    params.require(:device).permit(:uuid, :registration_id, :os)
  end

  def user_params
    params.require(:user).permit(
      :user_name, 
      :email, 
      :first_name, 
      :last_name, 
      :fb_id
    )
  end
end
