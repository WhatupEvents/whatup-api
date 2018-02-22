class CreateShoutVideo < ActiveRecord::Migration
  def change
    create_table :shout_videos do |t|
      t.integer :shout_id
      t.string :source, default: ''

      t.timestamps

      t.index [:shout_id]
    end

    add_attachment :shouts, :video
  end
end
