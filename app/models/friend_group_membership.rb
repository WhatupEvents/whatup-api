class FriendGroupMembership < ActiveRecord::Base
  belongs_to :friend_group, class_name: 'FriendGroup'
  belongs_to :member, class_name: 'User'

  validates :friend_group_id, presence: true
  validates :member_id, presence: true
end
