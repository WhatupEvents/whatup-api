class User < ActiveRecord::Base
  validates :email, uniqueness: true

  has_many :doorkeeper_access_tokens,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessToken',
    dependent: :destroy

  has_many :devices

  has_many :statuses

  has_many :friend_relationships_in,
           class_name: 'FriendRelationship',
           foreign_key: :friend_id

  has_many :friend_relationships_out,
           class_name: 'FriendRelationship',
           foreign_key: :person_id

  has_many :friends, through: :friend_relationships_out

  has_many :event_relationships
  has_many :events, through: :event_relationships

  has_many :friend_groups

  after_create :default_friend_groups

  def default_friend_groups
    self.friend_groups |= [
      FriendGroup.find_or_create_by(user_id: self.id, name: 'Fave', default: true),
      FriendGroup.find_or_create_by(user_id: self.id,name: 'School', default: true),
      FriendGroup.find_or_create_by(user_id: self.id,name: 'Work', default: true)
    ]
  end
end
