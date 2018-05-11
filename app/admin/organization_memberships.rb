ActiveAdmin.register OrganizationMembership do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :member, collection: current_admin_user.user.admin? ? User.all : User.where(id: current_admin_user.user.id)
      f.input :organization
    end
    f.actions
  end

  permit_params :user_id, :organization_id
end
