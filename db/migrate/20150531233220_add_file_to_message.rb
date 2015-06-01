class AddFileToMessage < ActiveRecord::Migration
  def change
    add_attachment :messages, :image
  end
end
