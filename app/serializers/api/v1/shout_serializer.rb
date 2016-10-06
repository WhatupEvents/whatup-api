class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :shouter, :user_id, :event_id, :source, :url

  def url
    object.image.url
  end

  def shouter
    User.find(object.user_id).name
  end
end
