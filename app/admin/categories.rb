ActiveAdmin.register Category do
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
    panel "Topics" do
      table_for category.topics do
        column :id do |topic|
          link_to(topic.id.to_s, '/admin/topics/'+topic.id.to_s)
        end
        column :name
      end
    end
  end

end
