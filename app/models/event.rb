class Event < ActiveRecord::Base
  validates :name, presence: true

  # TODO: dependent destroy?
  has_many :messages
  has_many :shouts

  has_many :participant_relationships, dependent: :destroy
  has_many :participants, through: :participant_relationships

  has_attached_file :image
  do_not_validate_attachment_file_type :image

  @@to_mile = 1/68.703

  scope :near_user, ->(current, distance) do
    where('latitude > ? AND latitude < ? ', 
          current.latitude.to_f-(distance*@@to_mile),
          current.latitude.to_f+(distance*@@to_mile))
    .where('longitude > ? AND longitude < ?',
           current.longitude.to_f-(distance*@@to_mile),
           current.longitude.to_f+(distance*@@to_mile))
  end

  scope :pub, -> { where(public: true) }

  scope :current, -> { where('start_time < ?', Time.now+2.days).where('end_at > ?', Time.now-2.hours) }
end
