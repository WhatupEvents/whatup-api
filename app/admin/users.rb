ActiveAdmin.register User do
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

  index do
    id_column
    column :first_name
    column :last_name
    column :email
    column :accepted_terms
    column :verified
    column :role
    actions
  end

  filter :first_name, as: :string
  filter :last_name, as: :string
  filter :email, as: :string
  filter :accepted_terms
  filter :verified
  filter :role
  filter :organizations
  filter :friends
  filter :events
  filter :created_at, as: :date_range

end
