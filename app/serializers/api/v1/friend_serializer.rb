class Api::V1::FriendSerializer < Api::V1::UserSerializer
  has_one :status, serializer: Api::V1::StatusSerializer

  def status
    current_status = object.statuses.current.last
    return Status.new(user_id: object.id) unless current_status
    current_status
  end
end
