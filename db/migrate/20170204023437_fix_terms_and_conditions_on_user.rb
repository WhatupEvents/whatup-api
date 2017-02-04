class FixTermsAndConditionsOnUser < ActiveRecord::Migration
  def change
    change_column :users, :accepted_terms, :boolean
  end
end
