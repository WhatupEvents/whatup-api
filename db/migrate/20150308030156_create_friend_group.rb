class CreateFriendGroup < ActiveRecord::Migration
  def change
    create_table :friend_groups do |t|
      t.integer :user_id
      t.string :name
      t.boolean :default, default: false

      t.timestamps

      t.index [:user_id]
    end
  end
end
