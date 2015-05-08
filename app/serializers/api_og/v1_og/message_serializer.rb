class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :sender_id, :event_id, :text, :created_at
end
