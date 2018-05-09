class ChangeShoutUserField < ActiveRecord::Migration
  def change
    rename_column :shouts, :user_id, :shouter_id
    add_column :shouts, :shouter_type, :string, default: "User"
  end
end
