class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string :registration_id
      t.string :uuid
    end

    add_index :devices, :user_id
  end
end
