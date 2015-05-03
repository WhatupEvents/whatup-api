class FriendGroupSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :members, serializer: MemberSerializer
end
