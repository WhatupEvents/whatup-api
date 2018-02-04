class ChangeUsernameField < ActiveRecord::Migration
  def change
    rename_column :users, :user_name, :user_id
    remove_column :users, :fb_id
  end
end
