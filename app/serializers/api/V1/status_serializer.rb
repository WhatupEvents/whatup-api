class Api::V1::StatusSerializer < ActiveModel::Serializer
  attributes :text, :created_at
end
