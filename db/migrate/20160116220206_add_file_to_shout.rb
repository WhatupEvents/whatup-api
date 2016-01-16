class AddFileToShout < ActiveRecord::Migration
  def change
    add_attachment :shouts, :image
    add_column :shouts, :source, :string, default: ''
  end
end
