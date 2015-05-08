class Api::V1::FriendSerializer < Api::V1::UserSerializer
  has_one :status, serializer: Api::V1::StatusSerializer

  def status
    object.statuses.last
  end
end
