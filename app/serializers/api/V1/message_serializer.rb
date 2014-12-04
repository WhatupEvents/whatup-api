class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :sender_id, :recipient_id, :text, :created_at
end
