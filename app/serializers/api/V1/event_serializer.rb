class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :event_id, :name, :created_at
  has_many :participants, serializer: ParticipantSerializer
end
