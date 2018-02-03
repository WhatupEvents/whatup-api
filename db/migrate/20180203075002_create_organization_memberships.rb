class CreateOrganizationMemberships < ActiveRecord::Migration
  def change
    create_table :organization_memberships do |t|
      t.integer :user_id
      t.integer :organization_id

      t.timestamps

      t.index [:user_id]
      t.index [:organization_id]
    end
  end
end
