class Api::V1::ShoutSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :user_id, :event_id, :source, :url

  def url
    object.image.url
  end
end
