class CreateUpping < ActiveRecord::Migration
  def change
    create_table :uppings do |t|
      t.integer :status_id
      t.integer :upped_by_id

      t.timestamps

      t.index [:status_id]
      t.index [:upped_by_id]
    end
  end
end
