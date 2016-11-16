class Api::V1::Me
  include ActiveModel::SerializerSupport

  attr_accessor :user, :access_token

  def initialize(user, access_token)
    @user = user
    @access_token = access_token
  end
end
