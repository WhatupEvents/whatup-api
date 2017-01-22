class Api::V1::UsersController < Api::V1::ApiController
  doorkeeper_for :all, except: [:create, :authenticate]

  def create
    @current_user = User.where('user_name = ? or email = ?', user_params['user_name'], user_params['email']).first || User.new
    if @current_user.new_record?
      @current_user.role = 'User'
      @current_user.accepted_terms = false
      @current_user.update(user_params)
      @current_user.save
      render_me :created
    else
      if user_params.has_key? 'accepted_terms'
        @current_user.update_attribute('accepted_terms', user_params['accepted_terms'])
      end
      @current_user.update_attribute('email', user_params['email'])
      render_me :ok
    end
  rescue Exception => e
    Rails.logger.info e.to_s
    head :bad_request
  end

  def add_friend
	  FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: User.find_by_user_name(params[:new_friend_username]).id)
		FriendRelationship.find_or_create_by(person_id: User.find_by_user_name(params[:new_friend_username]).id, friend_id: current_user.id)
    render json: {}, status: :created
  end

  def friends
    if (params['friends_fb_ids'])
			User.where('fb_id in (?)',JSON.parse(params['friends_fb_ids'])).each do |friend|
				FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: friend.id)
				FriendRelationship.find_or_create_by(person_id: friend.id, friend_id: current_user.id)
			end
    end
    render json: current_user.friends.order(first_name: :asc),
           each_serializer: Api::V1::FriendSerializer,
           status: :ok
  end

  def unregister
    current_device = Device.where(user_id: current_user.id, os: device_params[:os], uuid: device_params[:uuid]).first
    current_device.destroy
    render json: {}, status: :accepted
  end

  private

  def render_me(status)
    # Device.find_or_create_by({user_id: @current_user.id}.merge(device_params)} ??????
    device = Device.find_or_initialize_by(user_id: @current_user.id, os: device_params[:os])
    device.registration_id = device_params[:registration_id]
    device.uuid = device_params[:uuid]
    device.save

    # include:  ['user', 'user.status', 'access_token'],
    render json: current_me,
           serializer: Api::V1::MeSerializer,
           status: status
  end

  def current_me
    return Api::V1::Me.new({ user: @current_user, access_token: process_access_token })
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
      :fb_id,
      :accepted_terms,
      :source,
      :image
    )
  end
end
