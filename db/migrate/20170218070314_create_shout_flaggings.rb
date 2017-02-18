class CreateShoutFlaggings < ActiveRecord::Migration
  def change
    create_table :shout_flaggings do |t|
      t.integer :shout_id
      t.integer :flagged_by_id

      t.timestamps

      t.index [:shout_id]
      t.index [:flagged_by_id]
    end
  end
end
