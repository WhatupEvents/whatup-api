class ChangeTypeToOsOnDevices < ActiveRecord::Migration
  def change
    rename_column :devices, :type, :os
  end
end
