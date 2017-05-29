class FollowRelationship < ActiveRecord::Base
  validates :user_id, presence: true
  validates :follower_id, presence: true

  has_one :follower
  belongs_to :user
end
