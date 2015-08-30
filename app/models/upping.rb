class Upping < ActiveRecord::Base
  belongs_to :status
  belongs_to :upped_by, class_name: 'User'

  validates :status, presence: true
  validates :upped_by, presence: true
end
