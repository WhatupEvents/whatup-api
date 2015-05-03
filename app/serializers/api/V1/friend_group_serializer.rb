module Api
  module V1
    class FriendGroupSerializer < ActiveModel::Serializer
      attributes :id, :name

      has_many :members, serializer: Api::V1::MemberSerializer
    end
  end
end
