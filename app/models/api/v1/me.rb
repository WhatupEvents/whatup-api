class Api::V1::Me < ActiveRecord::Base
  # include ActiveModel::AttributeMethods
  # include ActiveModel::Serialization

  attr_accessor :user, :access_token

  def initialize(user, access_token)
    @user = user
    @access_token = access_token
  end
end
