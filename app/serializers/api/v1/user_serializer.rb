class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :role, :fb_id, :accepted_terms, :user_name, :url, :image_updated_at, :user_id

  has_one :status, serializer: Api::V1::StatusSerializer

  def url
    unless object.image.url.include? "missing.png"
      object.image.url.split('whatupevents-images/')[1].split('?')[0].gsub('/', '-').gsub('.','_')
    end
  end

  def status
    current_status = object.statuses.current.last
    return current_status || 
      Status.new(user_id: object.id, topic_id: 1, text: "", ups: 0)
  end

  def fb_id
    object.user_id
  end

  def user_name
    object.user_id
  end

  def role
    object.role.name
  end
end
