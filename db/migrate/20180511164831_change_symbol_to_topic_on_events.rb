class ChangeSymbolToTopicOnEvents < ActiveRecord::Migration
  def change
    rename_column :events, :symbol_id, :topic_id

    remove_index :topics, :symbol_id
    rename_column :topics, :symbol_id, :category_id
    add_index :topics, :category_id

    remove_index :statuses, :symbol_id
    rename_column :statuses, :symbol_id, :topic_id
    add_index :statuses, :topic_id
  end
end
