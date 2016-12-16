class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_at, :details, :location, :latitude, :longitude, :url, :symbol_id,
    :created_by_id, :created_at, :updated_at, :category_id, :public, :source, :image_updated_at, :notify
  has_many :participants, each_serializer: Api::V1::ParticipantSerializer

  def url
    object.image.url
  end

  def notify
    "#{serialization_options['current_user']} #{serialization_options[:current_user]}"
  end
end
