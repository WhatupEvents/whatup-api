class Api::V1::MeSerializer < ActiveModel::Serializer
  has_one :user, serializer: Api::V1::UserSerializer
  has_one :access_token, serializer: Api::V1::AccessTokenSerializer 

  def access_token
    object.attributes[:access_token]
  end

  def user
    object.attributes[:user]
  end
end
