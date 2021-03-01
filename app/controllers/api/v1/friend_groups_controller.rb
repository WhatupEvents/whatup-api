class Api::V1::FriendGroupsController < Api::V1::ApiController
  before_action :doorkeeper_authorize!
  before_action :find_friend_group, only: [:update, :destroy]

  def index
    render_groups
  end

  def create
    @friend_group = FriendGroup.create
    process_friend_group
  end

  def update
    process_friend_group
  end

  def destroy
    unless @friend_group.default
      @friend_group.destroy
    end
    render_groups
  end

  private

  def find_friend_group
    @friend_group = FriendGroup.find(params[:id])
  end

  def process_friend_group
    @friend_group.update_attributes(friend_group_params.merge({ user_id: current_user.id }))

    friend_ids_array = JSON.parse(params['friend_ids'])
    if friend_ids_array.empty?
      @friend_group.members = []
    end
    @friend_group.members = User.where('id in (?)', friend_ids_array)

    render_groups
  end

  def render_groups
    render json: current_user.friend_groups,
           each_serializer: Api::V1::FriendGroupSerializer,
           status: :ok
  end

  def friend_group_params
    params.require(:friend_group).permit(:name, :symbol_id)
  end
end
