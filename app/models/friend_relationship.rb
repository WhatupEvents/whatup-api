class FriendRelationship < ActiveRecord::Base
  belongs_to :person, class_name: 'User'
  belongs_to :friend, class_name: 'User'

  validates :person, presence: true
  validates :friend, presence: true
end
