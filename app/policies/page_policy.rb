class PagePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    case record.name
    when 'Dashboard'
      user.promoter? or user.admin?
    else
      false
    end
  end
end
