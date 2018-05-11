class Event < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :created_by, polymorphic: true

  belongs_to :category
  belongs_to :topic, foreign_key: :symbol_id

  # TODO: dependent destroy?
  has_many :messages
  has_many :shouts

  has_many :participant_relationships, dependent: :destroy
  has_many :participants, through: :participant_relationships

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

  @@from_mile = 1/68.703

  scope :near_user, ->(lat, long, distance) do
    where('latitude > ? AND latitude < ? ', 
          lat.to_f-(distance*@@from_mile),
          lat.to_f+(distance*@@from_mile))
    .where('longitude > ? AND longitude < ?',
           long.to_f-(distance*@@from_mile),
           long.to_f+(distance*@@from_mile))
  end

  scope :pub, -> { where(public: true) }

  scope :not_old, -> { where('end_at > ?', Time.now-2.hours) }
  scope :not_far_off, -> { where('start_time < ?', Time.now+4.days) }
  scope :current, -> { not_old.not_far_off }
  scope :jon_old, -> { where('end_at > ?', Time.now-2.days) }
  scope :jon_far_off, -> { where('start_time < ?', Time.now+4.days) }
  scope :jon_current, -> { jon_old.jon_far_off }

  scope :not_too_old, -> { where('end_at > ?', Time.now-10.days) }
  scope :for_shouts, -> { not_too_old.not_far_off }
  
  scope :not_flagged_for, ->(user_id) do
    select do |item|
      Flag.where(obj_class: item.class.to_s, obj_id: item.id, user_id: user_id).empty?
    end
  end
end
