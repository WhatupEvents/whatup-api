class AddCategoryToEvent < ActiveRecord::Migration
  def change
    add_column :events, :category_id, :integer
    rename_column :events, :address, :location
    rename_column :events, :description, :details
  end
end
