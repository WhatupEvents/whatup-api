class Organization < ActiveRecord::Base
  has_many :users, through: :organization_memberships
  has_many :organization_memberships 
end
