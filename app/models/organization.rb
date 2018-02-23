class Organization < ActiveRecord::Base
  has_many :members, through: :organization_memberships
  has_many :organization_memberships 

  has_many :events, as: :created_by

  has_many :followers, through: :follow_relationships
  has_many :follow_relationships, foreign_key: :followed_id

  validates :name, uniqueness: true
end
