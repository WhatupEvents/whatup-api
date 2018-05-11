class UserPolicy < ApplicationPolicy

  def index?
    user.admin? or user.promoter?
  end

  # if current_user.role == 'Unverified'
  #   head :bad_request

  def update?
    user.verified?
  end

  def destroy?
    user.admin?
  end
end
