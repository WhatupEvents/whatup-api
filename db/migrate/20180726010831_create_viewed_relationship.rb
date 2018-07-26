class CreateViewingRelationship < ActiveRecord::Migration
  def change
    create_table :viewing_relationships do |t|
      t.integer :user_id
      t.integer :shout_id

      t.timestamps
    end
  end
end
