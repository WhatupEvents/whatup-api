class Api::V1::UsersController < Api::V1::ApiController
  doorkeeper_for :all, except: [:create, :authenticate, :get_email, :check_uniqueness]

  def check_uniqueness
    if User.where(params[:unique_field] => params[:unique_value]).empty?
      render json: {}, status: :ok
    else
      head :bad_request
    end
  end

  def authenticate
    @current_user = User.where(user_id: user_params[:user_name] || user_params[:user_id], encrypted_password: user_params[:encrypted_password]).first ||
      User.where(email: user_params[:user_id], encrypted_password: user_params[:encrypted_password]).first
    if @current_user
      render_me :ok
    else
      head :unauthorized
    end
  end

  def create
    @current_user = User.where(user_id: user_params['user_name'] || user_params['user_id']).first || User.new
    if @current_user.new_record?

      if user_params['fb_token'] || user_params['firebase_token']
        @current_user.role = 'User'
      else
        @current_user.role = 'Unverified'
      end
      
      @current_user.accepted_terms = false
      @current_user.update(user_params)
      @current_user.save
      render_me :created
    else
      if user_params.has_key? 'accepted_terms'
        @current_user.update_attribute('accepted_terms', user_params['accepted_terms'])
      end
      # TODO: review this, seems like it is for later adding fb account to existing account
      if user_params['fb_id']
        if User.find_by_fb_id(user_params['fb_id'])
          head :gone
        else
          @current_user.update_attribute('fb_id', user_params['fb_id'])
          render_me :ok
        end
      else
        if user_params['email']
          @current_user.update_attribute('email', user_params['email'])
        end
        if user_params['encrypted_password']
          @current_user.update_attribute('encrypted_password', user_params['encrypted_password'])
        end
        render_me :ok
      end
    end
  end

  def update
    if current_user.role == 'Unverified'
      head :bad_request
    end

    @current_user = User.find(params[:id])
    @current_user.update_attributes(user_image_params)
    head :ok
  end

  def add_friend
    friend = User.find_by_user_id(params[:new_friend_username])
    if friend
      FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: friend.id)
      FriendRelationship.find_or_create_by(person_id: friend.id, friend_id: current_user.id)
      render json: {}, status: :created
    else
      render json: {}, status: :not_found
    end
  end

  def friends
    if (params['friends_fb_ids'])
      User.where('user_id in (?)',JSON.parse(params['friends_fb_ids'])).each do |friend|
        FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: friend.id)
	FriendRelationship.find_or_create_by(person_id: friend.id, friend_id: current_user.id)
      end
    end
    render json: current_user.friends.order(first_name: :asc),
           each_serializer: Api::V1::FriendSerializer,
           status: :ok
  end

  def flag
    Flag.create(user_id: current_user.id, obj_class: params[:object_class], obj_id: params[:object_id])
    render json: {}, status: :ok
  end

  def unregister
    current_device = Device.where(user_id: current_user.id, os: device_params[:os], uuid: device_params[:uuid]).first
    current_device.destroy
    render json: {}, status: :accepted
  end

  def interested
    user = User.find(params[:user_id])
    status = user.statuses.current.last
    if Rails.env != "development" && status.present?
      Resque.enqueue(
        FcmMessageJob,{ 
          status_text: status.text,
          friend_name: current_user.name
        }, user.id
      )
    end
    head :ok
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

  def user_image_params
    params.permit(:source, :image)
  end

  def user_params
    params.require(:user).permit(
      :user_name,
      :user_id,
      :email, 
      :first_name, 
      :last_name, 
      :fb_id,
      :fb_token,
      :firebase_token,
      :accepted_terms,
      :encrypted_password,
      :source,
      :image
    )
  end
end
