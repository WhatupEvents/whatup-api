class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :details, :location, :latitude, :longitude,
    :symbol_id, :created_by_id, :category_id, :public
  has_many :participants, each_serializer: Api::V1::ParticipantSerializer
end
