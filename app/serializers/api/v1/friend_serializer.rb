class Api::V1::FriendSerializer < Api::V1::UserSerializer
  has_one :status, serializer: Api::V1::StatusSerializer

  def status
    current_status = object.statuses.current.last
    # may need to correct these values
    return Status.new(user_id: object.id, symbol_id: 1, text: "", ups: 0) unless current_status
    current_status
  end
end
