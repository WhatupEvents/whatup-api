class ShoutUpping < ActiveRecord::Base
  belongs_to :shout
  belongs_to :upped_by, class_name: 'User'

  validates :shout, presence: true
  validates :upped_by, presence: true
end
