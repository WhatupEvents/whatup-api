ActiveAdmin.register Shout do
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

  show do
    attributes_table do
      row :shouter
      row :text
      row :image do |shout|
        image_tag shout.url.split("?")[0]
      end
    end
  end

  index do
    id_column
    column :text
    column :shouter_id
    column :shouter_type
    column :created_at
  end

  permit_params :text, :shouter_id, :shouter_type, :created_at
end
