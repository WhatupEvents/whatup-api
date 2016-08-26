class Event < ActiveRecord::Base
  validates :name, presence: true

  # TODO: dependent destroy?
  has_many :messages
  has_many :shouts

  has_many :participant_relationships, dependent: :destroy
  has_many :participants, through: :participant_relationships

  has_attached_file :image
  do_not_validate_attachment_file_type :image

  @@fifteen_mile = 15.0/68.70795454545454
  @@fifteen_to_mile = 15.0/69.16022727272727

  scope :near_user, ->(current) do
    where('latitude > ? AND latitude < ? ', 
          current.latitude.to_f-@@fifteen_mile,
          current.latitude.to_f+@@fifteen_mile)
    .where('longitude > ? AND longitude < ?',
           current.longitude.to_f-@@fifteen_mile,
           current.longitude.to_f+@@fifteen_mile)
  end

  scope :pub, -> { where(public: true) }

  scope :current, -> { where('start_time < ?', Time.now+2.days).where('end_at > ?', Time.now-2.hours) }
end
