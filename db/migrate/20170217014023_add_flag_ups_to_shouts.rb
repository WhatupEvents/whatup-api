class AddFlagUpsToShouts < ActiveRecord::Migration
  def change
    add_column :shouts, :flag, :integer
    add_column :shouts, :ups, :integer
  end
end
