module Api
  module V1
    class UsersController < ApiController
      doorkeeper_for :all, except: [:create, :authenticate]

      def create
        @current_user = User.find_or_initialize_by(user_params)
        if @current_user.new_record?
          @current_user.save
          render_me :created
        else
          render_me :ok
        end
      rescue
        head :bad_request
      end

      def friends
        User.where('fb_id in (?)',JSON.parse(params['friends_fb_ids'])).each do |friend|
          FriendRelationship.find_or_create_by(person_id: current_user.id, friend_id: friend.id)
          FriendRelationship.find_or_create_by(friend_id: current_user.id, person_id: friend.id)
        end
        render json: current_user.friends,
               each_serializer: Api::V1::FriendSerializer,
               status: :ok
      end

      def gcm_register
        current_device = Device.find_by_uuid(device_params[:uuid])
        current_device.update_attributes(device_params.permit(:registration_id))
      end

      private

      def render_me(status)
        Device.find_or_create_by(device_params.merge(user_id: @current_user.id))
        render json: current_me,
               serializer: Api::V1::MeSerializer,
               status: status
      end

      def current_me
        Me.new(@current_user, process_access_token)
      end

      def device_params
        params.require(:device).permit(:uuid, :registration_id)
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
  end
end
