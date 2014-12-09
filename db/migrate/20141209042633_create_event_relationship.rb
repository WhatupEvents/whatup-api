class CreateEventRelationship < ActiveRecord::Migration
  def change
    create_table :event_relationships do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps

      t.index [:user_id]
      t.index [:event_id]
    end
  end
end
