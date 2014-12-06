class CreateParticipantRelationship < ActiveRecord::Migration
  def change
    create_table :participant_relationships do |t|
      t.integer :event_id
      t.integer :participant_id

      t.timestamps

      t.index [:event_id]
      t.index [:participant_id]
    end
  end
end
