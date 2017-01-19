class ChangeShoutUrlToText < ActiveRecord::Migration
  def change
    change_column :shouts, :url, :text
  end
end
