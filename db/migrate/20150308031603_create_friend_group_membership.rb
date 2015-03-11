class CreateFriendGroupMembership < ActiveRecord::Migration
  def change
    create_table :friend_group_memberships do |t|
      t.integer :friend_group_id
      t.integer :member_id
      
      t.timestamps

      t.index [:friend_group_id]
      t.index [:member_id]
    end
  end
end
