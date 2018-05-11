class AdminAdapter < ActiveAdmin::PunditAdapter
  def authorize?
    super
  end

  def scope_collection(collection, action = Auth::READ)
    first = collection.first
    if first && first.class == User && user.user.promoter?
      collection.where(id: user.user_id)
    else
      super
    end
  end
end
