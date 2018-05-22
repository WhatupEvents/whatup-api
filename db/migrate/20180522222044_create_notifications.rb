class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :text
      t.string :data

      t.timestamps

      t.index [:user_id]
    end
  end
end
