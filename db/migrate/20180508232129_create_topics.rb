class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :symbol_id

      t.timestamps

      t.index [:symbol_id]
    end
  end
end
