class Api::V1::AccessTokenSerializer < ActiveModel::Serializer
  attributes :token, :expires_in
end
