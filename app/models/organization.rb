class Organization < ActiveRecord::Base
  has_many :members, through: :organization_memberships
  has_many :organization_memberships 

  has_many :events, as: :created_by
end
