class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :user_id, :event_id, :source, :url

  def url
    unless object.image.url.include? "missing.png"
      object.image.url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
    end
  end

  def shouter
    User.find(object.user_id).name
  end
end
