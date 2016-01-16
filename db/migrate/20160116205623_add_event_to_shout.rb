class AddEventToShout < ActiveRecord::Migration
  def change
    add_column :shouts, :event_id, :integer
  end
end
