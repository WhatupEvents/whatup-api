class AddSymbolToFriendGroups < ActiveRecord::Migration
  def change
    add_column :friend_groups, :symbol_id, :integer
  end
end
