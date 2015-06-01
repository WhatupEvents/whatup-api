class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :sender_id, :event_id, :text, :media, :source, :created_at

  has_one :url

  def url
    object.image.url
  end
end
