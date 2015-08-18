class AddGeoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :longitude, :string
    add_column :events, :latitude, :string
  end
end
