class AddInfoToEvent < ActiveRecord::Migration
  def change
    add_column :events, :description, :string
    add_column :events, :address, :string
    add_column :events, :symbol_id, :integer
    add_column :events, :start_time, :datetime
    add_column :events, :public, :boolean
  end
end
