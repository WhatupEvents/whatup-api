class AddVersionToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :version, :string
  end
end
