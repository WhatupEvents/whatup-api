class User < ActiveRecord::Base
  validates :email, uniqueness: true
  validates :user_name, uniqueness: true

  has_many :doorkeeper_access_tokens,
    foreign_key: :resource_owner_id,
    class_name: 'Doorkeeper::AccessToken',
    dependent: :destroy

  has_many :follow_relationships_out, foreign_key: :follower_id,
           class_name: 'FollowRelationship'
  has_many :followings, through: :follow_relationships_out, source: :followed

  has_many :follow_relationships_in, foreign_key: :followed_id,
           class_name: 'FollowRelationship'
  has_many :followers, through: :follow_relationships_in, source: :follower

  has_many :devices

  has_many :flags

  has_many :statuses

  has_many :shouts, dependent: :destroy

  has_many :friend_relationships_in,
           class_name: 'FriendRelationship',
           foreign_key: :friend_id

  has_many :friend_relationships_out,
           class_name: 'FriendRelationship',
           foreign_key: :person_id

  has_many :friends, through: :friend_relationships_out

  has_many :friend_groups

  has_many :events, foreign_key: :created_by_id, dependent: :destroy

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

  scope :not_flagged_for, ->(user_id) do
    select do |item|
      !Flag.where(obj_class: item.class.to_s, obj_id: item.id, user_id: user_id).present?
    end
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
    first_name + " " + last_name
  end
end
