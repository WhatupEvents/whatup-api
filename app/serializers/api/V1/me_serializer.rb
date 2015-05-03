module Api
  module V1
    class MeSerializer < ActiveModel::Serializer
      has_one :user, serializer: Api::V1::UserSerializer
      has_one :access_token, serializer: Api::V1::AccessTokenSerializer 
    end
  end
end
