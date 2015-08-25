class Api::V1::UserWithFriendsSerializer < Api::V1::UserSerializer
  has_many :friends, serializer: Api::V1::FriendSerializer
  has_many :friend_groups, serializer: Api::V1::FriendGroupSerializer
end
