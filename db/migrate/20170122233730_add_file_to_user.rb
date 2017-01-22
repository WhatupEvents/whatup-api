class AddFileToUser < ActiveRecord::Migration
  def change
    add_attachment :users, :image
    add_column :users, :source, :string, default: ''
  end
end
