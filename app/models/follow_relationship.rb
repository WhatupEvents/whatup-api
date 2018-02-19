class FollowRelationship < ActiveRecord::Base
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'Organization', foreign_key: :followed_id
end
