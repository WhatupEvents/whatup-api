class AddNotNullToEventSymbolId < ActiveRecord::Migration
  def change
    change_column :events, :symbol_id, :integer, null: false
  end
end
