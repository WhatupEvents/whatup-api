class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :text
      t.integer :user_id
      t.integer :symbol_id

      t.timestamps

      t.index [:user_id]
      t.index [:symbol_id]
    end
  end
end
