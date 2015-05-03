module Api
  module V1
    class StatusSerializer < ActiveModel::Serializer
      attributes :text, :created_at
    end
  end
end
