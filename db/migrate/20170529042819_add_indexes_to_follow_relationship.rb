class AddIndexesToFollowRelationship < ActiveRecord::Migration
  def change
    rename_column :follow_relationships, :user_id, :followed_id
    add_index :follow_relationships, :follower_id
    add_index :follow_relationships, :followed_id
  end
end
