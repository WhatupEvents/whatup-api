class AddUnreadToParticipantRelationships < ActiveRecord::Migration
  def change
    add_column :participant_relationships, :unread, :integer
  end
end
