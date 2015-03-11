class Api::V1::FriendGroupSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :members, serializer: MemberSerializer
end
