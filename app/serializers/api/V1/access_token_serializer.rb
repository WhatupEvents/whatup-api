class AccessTokenSerializer < ActiveModel::Serializer
  attributes :token, :expires_in
end
