class AddLikesToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :ups, :integer
  end
end
