class Api::V1::StatusSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :upped_by, :ups, :symbol_id, :topic_id, :valid_until

  def text
    if object.id.nil?
      if Rails.env != "development" 
        # Resque.enqueue(
        #   FcmMessageJob,
        #   {},object.user_id
        # )
      end
      return ""
    end
    object.text
  end

  def upped_by
    object.upped_by.map(&:id)
  end

  def valid_until
    object.valid_until || object.created_at
  end

  def symbol_id
    object.topic_id
  end
end
