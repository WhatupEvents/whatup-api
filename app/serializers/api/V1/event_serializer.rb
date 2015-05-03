class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :description, :address, :symbol_id, :public, :created_by_id
  has_many :participants, each_serializer: ParticipantSerializer
end
