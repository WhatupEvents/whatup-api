class EventPolicy < ApplicationPolicy
  def index?
    user.admin? or user.promoter?
  end

  # if current_user.role == 'Unverified'
  #   head :bad_request
  #   return
  # end

  def create?
    user.verified?
  end

  # Only the event creator or Admins can update events
  # Regular users cannot make events public
  def update?
    creator_ids = get_creator_ids
  
    user.admin? || (!record.public && creator_ids.include?(user.id)) || (record.public && user.promoter?)
  end

  def destroy?
    creator_ids = get_creator_ids

    creator_ids.include?(user.id) || user.admin?
  end

  # if event is from an organization, need to look at creating organization members
  def get_creator_ids
    creator_ids = [record.created_by_id]
    if record.created_by_type == "Organization"
      creator_ids = record.created_by.members.map(&:id)
    end
    return creator_ids
  end

end
