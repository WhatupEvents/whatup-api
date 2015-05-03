module Api
  module V1
    class MeSerializer < ActiveModel::Serializer
      has_one :user, serializer: UserSerializer
      has_one :access_token, serializer: AccessTokenSerializer 
    end
  end
end
