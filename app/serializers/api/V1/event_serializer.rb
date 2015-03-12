class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :description, :address, :symbol_id, :public
  has_many :participants, serializer: ParticipantSerializer
end
