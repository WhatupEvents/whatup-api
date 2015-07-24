class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :details, :location, :symbol_id, :public, :created_by_id, :category_id
  has_many :participants, each_serializer: Api::V1::ParticipantSerializer
end
