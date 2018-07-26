class ViewingRelationship < ActiveRecord::Base
  belongs_to :shout
  belongs_to :viewer, class_name: 'User', foreign_key: :user_id

  validates :shout, presence: true
  validates :viewer, presence: true
end
