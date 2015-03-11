class FriendGroup < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :user
  has_many :friend_group_relationships
  has_many :members, 
    through: :friend_group_relationships
end
