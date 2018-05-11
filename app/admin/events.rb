ActiveAdmin.register Event do
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
    column :name
    column :created_by
    column :details
    column :location
    column :category
    column :topic
    column :start_time
    column :end_at
  end

  filter :name, as: :string
  filter :details, as: :string
  filter :created_by_type
  filter :category
  filter :topic
  filter :participants
  filter :start_time
  filter :end_at
  filter :public
  filter :latitude, as: :numeric
  filter :longitude, as: :numeric
  filter :location, as: :string

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :details
      f.input :created_by_type, collection: ["User", "Organization"]
      f.input :created_by_id, as: :select, collection: ((current_admin_user.user.admin? ? User.all : User.where(id: current_admin_user.user.id)) + Organization.all).map{|c| [c.class.to_s+" - "+c.name, c.id]}, label: 'Created by (must match type above)'
      f.input :location
      f.input :latitude
      f.input :longitude
      f.input :public
      f.input :category
      f.input :topic
      f.input :start_time
      f.input :end_at
    end
    f.actions
  end

  permit_params :name, :details, :created_by_type, :created_by_id, :location, :longitude, :latitude, :public, :category_id, :topic_id, :start_time, :end_at
end
