class Api::V1::CategorySerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :topics, each_serializer: Api::V1::TopicSerializer
end
