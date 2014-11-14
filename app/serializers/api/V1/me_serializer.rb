class Api::V1::MeSerializer < ActiveModel::Serializer
  has_one :user, serializer: UserSerializer
  has_one :access_token, serializer: AccessTokenSerializer 
end

