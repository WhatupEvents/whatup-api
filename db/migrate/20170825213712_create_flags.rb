class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.integer :user_id
      t.string :obj_id
      t.string :obj_class
    end

    add_index :flags, :user_id
  end
end
