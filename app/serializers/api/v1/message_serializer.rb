class Api::V1::MessageSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :sender, :event_id, :text, :media, :source, :created_at, :url

  def url
    unless object.image.url.include? "missing.png"
      object.image.url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
    end
  end

  def sender
    User.find(object.sender_id).name
  end
end
