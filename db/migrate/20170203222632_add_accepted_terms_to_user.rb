class AddAcceptedTermsToUser < ActiveRecord::Migration
  def change
    add_column :users, :accepted_terms, :string
  end
end
