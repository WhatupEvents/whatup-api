class Event < ActiveRecord::Base
  validates :name, presence: true

  # TODO: dependent destroy?
  has_many :messages

  has_many :participant_relationships
  has_many :participants, through: :participant_relationships

  has_attached_file :image
  do_not_validate_attachment_file_type :image
end
