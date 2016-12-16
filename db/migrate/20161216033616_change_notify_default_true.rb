class ChangeNotifyDefaultTrue < ActiveRecord::Migration
  def change
    change_column :participant_relationships, :notify, :boolean, :default => true
  end
end
