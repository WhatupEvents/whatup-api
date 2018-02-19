class AddCreatedByTypeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :created_by_type, :string
    add_index :events, [:created_by_type, :created_by_id]
  end
end
