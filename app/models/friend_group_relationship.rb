class FriendGroupRelationship < ActiveRecord::Base
  belongs_to :group, class_name: 'FriendGroup'
  belongs_to :member, class_name: 'User'

  validates :group, presence: true
  validates :member, presence: true
end
