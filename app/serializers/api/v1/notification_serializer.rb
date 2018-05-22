class Api::V1::NotificationSerializer < ActiveModel::Serializer
  attributes :id, :text, :data, :created_at
end
