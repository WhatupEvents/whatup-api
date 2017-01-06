class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender, :event_id, :text, :media, :source, :created_at, :url

  def url
    object.image.url if object.image
  end

  def sender
    User.find(object.sender_id).name
  end
end
