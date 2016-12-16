class AddNotifyToParticipantRelationships < ActiveRecord::Migration
  def change
    add_column :participant_relationships, :notify, :boolean
  end
end
