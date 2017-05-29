class FollowRelationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :user

  validates :follower, presence: true
  validates :user, presence: true
end
