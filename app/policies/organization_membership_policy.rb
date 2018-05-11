class OrganizationMembershipPolicy < ApplicationPolicy
  def index?
    user.admin? or user.promoter?
  end

  def create?
    user.admin? or user.promoter?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
