class Event < ActiveRecord::Base
  validates :name, presence: true

  has_many :messages

  has_many :participant_relationships
  has_many :participants, through: :participant_relationships

end
