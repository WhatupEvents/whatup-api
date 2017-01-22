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

  has_many :friend_groups

  after_create :default_friend_groups

  has_attached_file :image,
    :storage => :s3,
    :bucket => 'whatupevents-images',
    :s3_region => 'us-east-2',
    :s3_host_name => 's3.us-east-2.amazonaws.com',
    :s3_permissions => :private,
    :path => ':class/:attachment/:id/:filename',
    :s3_credentials => Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
     access_key_id: "AKIAJSKGHQFVPEXZZGMA",
     secret_access_key: "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"
    }
  end

  def default_friend_groups
    FriendGroup.find_or_create_by(user_id: self.id, name: 'All', default: true, symbol_id: 0)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'Favorites', default: true, symbol_id: -3)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'School', default: true, symbol_id: -2)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'Work', default: true, symbol_id: -1)
  end

  def current_events
    # TODO: decide whether we want to delete events and archive any data
    Event.current.joins(:participants).where('users.id = ?', id).where('public = 0')
  end

  def name
    first_name + " " + last_name
  end
end
