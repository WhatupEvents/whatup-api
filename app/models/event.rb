class Event < ActiveRecord::Base
  validates :name, presence: true

  # TODO: dependent destroy?
  has_many :messages
  has_many :shouts

  has_many :participant_relationships, dependent: :destroy
  has_many :participants, through: :participant_relationships

  has_attached_file :image,
    storage: :s3,
    s3_credentials: Proc.new{|p| p.instance.s3_credentials}
  do_not_validate_attachment_file_type :image

  def s3_credentials
    {
     bucket: "whatupevents-images",
     access_key_id: "AKIAIF5LMWPOUEEJMVCA",
     secret_access_key: "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"
    }
  end

  @@from_mile = 1/68.703

  scope :near_user, ->(current, distance) do
    where('latitude > ? AND latitude < ? ', 
          current.latitude.to_f-(distance*@@from_mile),
          current.latitude.to_f+(distance*@@from_mile))
    .where('longitude > ? AND longitude < ?',
           current.longitude.to_f-(distance*@@from_mile),
           current.longitude.to_f+(distance*@@from_mile))
  end

  scope :pub, -> { where(public: true) }

  scope :current, -> { where('start_time < ?', Time.now+2.days).where('end_at > ?', Time.now-2.hours) }
end
