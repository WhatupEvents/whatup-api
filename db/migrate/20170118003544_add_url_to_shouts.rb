class AddUrlToShouts < ActiveRecord::Migration
  def change
    add_column :url, :status, :string
  end
end
