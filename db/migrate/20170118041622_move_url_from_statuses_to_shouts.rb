class MoveUrlFromStatusesToShouts < ActiveRecord::Migration
  def change
    remove_column :statuses, :url, :string
    add_column :shouts, :url, :string
  end
end
