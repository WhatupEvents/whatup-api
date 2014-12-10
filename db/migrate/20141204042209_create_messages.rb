class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :event_id
      t.string :text

      t.timestamps
    end
  end
end
