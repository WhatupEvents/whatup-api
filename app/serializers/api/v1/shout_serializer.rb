class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :text, :created_at, :user_id, :event_id
end
