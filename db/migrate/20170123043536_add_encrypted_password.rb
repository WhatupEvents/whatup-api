class AddEncryptedPassword < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_password, :string, default: ''
  end
end
