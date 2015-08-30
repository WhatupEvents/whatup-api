class Status < ActiveRecord::Base
  belongs_to :user
  has_many :uppings
  has_many :upped_by, class_name: 'User', through: :uppings

  scope :current, lambda { where('created_at >= ?', Time.now - 16.hour) }
end
