class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :name
    end

    remove_column :users, :role
    add_column :users, :role_id, :integer, default: 1
    add_index :users, :role_id
  end

  def down
    drop_table :roles

    add_column :users, :role, :string
    remove_index :users, :role_id
    remove_column :users, :role_id
  end
end
