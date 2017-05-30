class Api::V1::StatusSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at, :upped_by, :ups, :symbol_id

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
end
