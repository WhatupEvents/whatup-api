class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :event_id, :source, :url

  def url
    object.image.url
  end

  def shouter
    User.find(object.user_id).name
  end
end
