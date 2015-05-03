class MessageSerializer < ActiveModel::Serializer
  attributes :sender_id, :event_id, :text, :created_at
end
