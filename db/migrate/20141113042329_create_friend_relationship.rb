class CreateFriendRelationship < ActiveRecord::Migration
  def change
    create_table :friend_relationships do |t|
      t.integer :person_id
      t.integer :friend_id

      t.timestamps

      t.index [:person_id]
      t.index [:friend_id]
    end
  end
end
