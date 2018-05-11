class ChangeSymbolToTopicOnEvents < ActiveRecord::Migration
  def change
    rename_column :events, :symbol_id, :topic_id
    rename_column :topics, :symbol_id, :category_id
    rename_column :statuses, :symbol_id, :topic_id
  end
end
