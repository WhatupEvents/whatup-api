class FriendSerializer < UserSerializer
  has_one :status, serializer: StatusSerializer

  def status
    object.statuses.last
  end
end
