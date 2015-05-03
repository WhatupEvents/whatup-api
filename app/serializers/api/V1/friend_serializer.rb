module Api
  module V1
    class FriendSerializer < Api::V1::UserSerializer
      has_one :status, serializer: StatusSerializer

      def status
        object.statuses.last
      end
    end
  end
end
