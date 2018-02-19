class OrganizationMembership < ActiveRecord::Base
  belongs_to :member, class_name: 'User', foreign_key: :user_id
  belongs_to :organization

  validates :user, presence: true
  validates :organization, presence: true
end
