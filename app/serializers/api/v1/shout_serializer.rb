class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :user_id, :event_id, :source, :url

  def url
    object.image.url unless object.image.url.include? "missing.png"
  end

  def shouter
    User.find(object.user_id).name
  end
end
