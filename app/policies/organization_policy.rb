class OrganizationPolicy < ApplicationPolicy

  # if current_user.role != 'Promoter' && current_user.role != 'Admin'
  #   head :bad_request
  #   return
  # end

  def index?
    user.promoter? or user.admin?
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
