class ViewingRelationship < ActiveRecord::Base
  belongs_to :shout
  belongs_to :viewer, class_name: 'User'

  validates :shout, presence: true
  validates :viewer, presence: true
end
