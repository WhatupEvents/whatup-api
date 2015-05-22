class Api::V1::Me
  attr_accessor :user, :access_token

  def initialize(user, access_token)
    @user = user
    @access_token = access_token
  end
end