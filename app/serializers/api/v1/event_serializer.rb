class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_at, :details, :location, :latitude, :longitude, :url,
    :symbol_id, :created_by_id, :created_at, :updated_at, :category_id, :public, :source
  has_many :participants, each_serializer: Api::V1::ParticipantSerializer

  def url
    object.image.url
  end
end
