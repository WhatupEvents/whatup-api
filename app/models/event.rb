class Event < ActiveRecord::Base
  validates :name, presence: true

  # TODO: dependent destroy?
  has_many :messages

  has_many :participant_relationships, dependent: :destroy
  has_many :participants, through: :participant_relationships

  has_attached_file :image
  do_not_validate_attachment_file_type :image

  @@lat_to_feet = 15.0/68.70795454545454
  @@long_to_feet = 15.0/69.16022727272727

  scope :with_user, ->(current) do
    where('latitude > ? AND latitude < ? ', 
          current.latitude.to_f*(1.0-@@lat_to_feet),
          current.latitude.to_f*(1.0+@@lat_to_feet))
    .where('longitude > ? AND longitude < ?',
           current.longitude.to_f*(1.0+@@long_to_feet),
           current.longitude.to_f*(1.0-@@long_to_feet))
  end

  scope :pub, -> { where(public: true) }
end
