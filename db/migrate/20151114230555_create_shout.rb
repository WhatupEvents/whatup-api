class CreateShout < ActiveRecord::Migration
  def change
    create_table :shouts do |t|
      t.integer :user_id
      t.string :text

      t.timestamps
    end
  end
end
