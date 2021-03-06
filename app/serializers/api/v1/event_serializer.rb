class Api::V1::EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :start_time, :end_at, :details, :location, :latitude, :longitude, :url, :symbol_id, :topic_id, :organization_name, :organization_location,
    :created_by_id, :created_by_type, :created_at, :updated_at, :category_id, :public, :source, :image_updated_at, :notify
  has_many :participants, each_serializer: Api::V1::ParticipantSerializer

  def url
    url = object.url
    if url.nil? || url.empty?
      url = object.image.url
    end

    if url.include? "missing.png"
      return nil
    end

    url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
  end

  def notify
    participant = object.participant_relationships.select{|p| p.participant_id == serialization_options[:current_user]}[0]
    participant ? participant.notify : false
  end

  def organization_name
    object.created_by_type == "Organization" ? object.created_by.name : ""
  end

  def organization_location
    object.created_by_type == "Organization" ? object.created_by.location : ""
  end

  def symbol_id
    object.topic_id
  end
end
