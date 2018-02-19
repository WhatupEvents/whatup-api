class AddModeToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :model, :string
  end
end
