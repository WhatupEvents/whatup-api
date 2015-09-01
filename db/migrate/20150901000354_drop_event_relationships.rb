class DropEventRelationships < ActiveRecord::Migration
  def change
    drop_table :event_relationships
  end
end
