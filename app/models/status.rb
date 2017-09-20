class Status < ActiveRecord::Base
  belongs_to :user
  has_many :uppings
  has_many :upped_by, class_name: 'User', through: :uppings

  scope :current, lambda { where('valid_until >= ?', Time.now) }
end
