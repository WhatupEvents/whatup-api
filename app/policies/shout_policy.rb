class ShoutPolicy < ApplicationPolicy

# if current_user.role == 'Unverified'
#   head :bad_request
#   return
# end

  def create?
    user.verified?
  end

  def update?
    user.verified?
  end

  def destroy?
    user.id == record.shouter_id
  end
end
