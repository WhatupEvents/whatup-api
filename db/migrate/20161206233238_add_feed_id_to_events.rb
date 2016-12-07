class AddFeedIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :feed_id, :integer
  end
end
