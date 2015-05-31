class AddMediaToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :media, :string
    add_column :messages, :source, :string
  end
end
