class FollowRelationship < ActiveRecord::Base
  validates :user_id, presence: true
  validates :follower_id, presence: true

  belongs_to :follower, class_name: 'User'
  belongs_to :user
end
