class CreateShoutUppings < ActiveRecord::Migration
  def change
    create_table :shout_uppings do |t|
      t.integer :shout_id
      t.integer :upped_by_id

      t.timestamps

      t.index [:shout_id]
      t.index [:upped_by_id]
    end
  end
end
