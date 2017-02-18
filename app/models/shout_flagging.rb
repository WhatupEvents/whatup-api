class ShoutFlagging < ActiveRecord::Base
  belongs_to :shout
  belongs_to :flagged_by, class_name: 'User'

  validates :shout, presence: true
  validates :flagged_by, presence: true
end
