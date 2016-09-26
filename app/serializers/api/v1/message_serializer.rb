class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :sender, :event_id, :text, :media, :source, :created_at, :url

  def url
    return if object.image.url == "/images/original/missing.png"
  end

  def sender
    User.find(object.sender_id).name
  end
end
