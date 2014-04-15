class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :account
      t.belongs_to :group
      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :memberships, :account_id
    add_index :memberships, :group_id
  end
end
