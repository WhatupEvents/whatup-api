module Api
  module V1
    class AccessTokenSerializer < ActiveModel::Serializer
      attributes :token, :expires_in
    end
  end
end
