class ParticipantRelationship < ActiveRecord::Base
  belongs_to :participant, class_name: 'User'
  belongs_to :event

  validates :participant, presence: true
  validates :event, presence: true
end
