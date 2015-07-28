class FriendGroup < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :user
  has_many :friend_group_memberships
  has_many :members, class_name: 'User',
    through: :friend_group_memberships
end
