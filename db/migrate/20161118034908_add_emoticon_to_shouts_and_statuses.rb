class AddEmoticonToShoutsAndStatuses < ActiveRecord::Migration
  def change
    execute "ALTER TABLE statuses CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE statuses MODIFY text VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE shouts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
    execute "ALTER TABLE shouts MODIFY text VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
  end
end
