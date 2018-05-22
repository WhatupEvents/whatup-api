class User < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :user_id, uniqueness: true

  belongs_to :role

  has_many :organization_memberships
  has_many :organizations, through: :organization_memberships

  has_many :doorkeeper_access_tokens,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessToken',
    dependent: :destroy

  # has_many :follow_relationships, foreign_key: :follower_id
  # has_many :followings, through: :follow_relationships

  has_many :devices

  has_many :flags

  has_many :statuses
  has_many :messages, foreign_key: :sender_id, dependent: :destroy
  has_many :shouts, foreign_key: :shouter_id, dependent: :destroy

  # has_many :friend_relationships_in,
  #          class_name: 'FriendRelationship',
  #          foreign_key: :friend_id

  has_many :friend_relationships, foreign_key: :person_id
  has_many :friends, through: :friend_relationships
  has_many :friend_groups

  has_many :events, as: :created_by

  has_many :notifications

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
     access_key_id: ENV['AWS_ACCESS_KEY'],
     secret_access_key: ENV['AWS_SECRET_KEY']
    }
  end

  def default_friend_groups
    FriendGroup.find_or_create_by(user_id: self.id, name: 'All', default: true, symbol_id: 0)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'Favorites', default: true, symbol_id: 1)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'School', default: true, symbol_id: 2)
    FriendGroup.find_or_create_by(user_id: self.id, name: 'Work', default: true, symbol_id: 3)
  end

  def current_events
    # TODO: decide whether we want to delete events and archive any data
    my_events = events.where('public = 0').not_old.order(start_time: :desc)
    friend_events = Event.not_old.joins(:participants).where('users.id = ?', id).where('public = 0').order(start_time: :desc)
    return my_events | friend_events
  end

  def name
    first_name + ' ' + last_name
  end

  def admin?
    role.name == 'Admin'
  end

  def promoter?
    role.name == 'Promoter'
  end

  def verified?
    role.name != 'Unverified'
  end
end
