class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :description, :address, :symbol_id, :public, :created_by_id
  has_many :participants, serializer: ParticipantSerializer
end
