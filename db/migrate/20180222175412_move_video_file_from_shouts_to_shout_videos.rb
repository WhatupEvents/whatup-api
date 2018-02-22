class MoveVideoFileFromShoutsToShoutVideos < ActiveRecord::Migration
  def change
    remove_attachment :shouts, :video
    add_attachment :shout_videos, :video
  end
end
