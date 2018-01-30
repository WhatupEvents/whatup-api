class AddEmoticonToEvents < ActiveRecord::Migration
  def change
    execute "ALTER TABLE events CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE events MODIFY details VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
