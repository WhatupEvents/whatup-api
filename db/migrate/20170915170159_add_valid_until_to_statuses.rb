class AddValidUntilToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :valid_until, :datetime
  end
end
