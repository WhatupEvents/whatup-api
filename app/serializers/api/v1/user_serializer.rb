class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :first_name, :last_name, :email, :role, :fb_id
  has_one :status, serializer: Api::V1::StatusSerializer

  def status
    current_status = object.statuses.current.last
    return current_status || 
      Status.new(user_id: object.id, symbol_id: 0, created_at: Time.now)
  end
end
