class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :first_name, :last_name, :email, :fb_id
end
