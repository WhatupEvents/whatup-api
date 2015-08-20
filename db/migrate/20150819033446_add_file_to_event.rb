class AddFileToEvent < ActiveRecord::Migration
  def change
    add_attachment :events, :image
    add_column :events, :source, :string, default: ''
  end
end
