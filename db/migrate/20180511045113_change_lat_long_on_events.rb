class ChangeLatLongOnEvents < ActiveRecord::Migration
  def change
    change_column :events, :latitude, :double
    change_column :events, :longitude, :double
  end
end
