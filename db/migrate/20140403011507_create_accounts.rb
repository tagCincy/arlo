class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :username, null: false
      t.text :bio
      t.string :avatar
      t.integer :role
      t.belongs_to :user

      t.timestamps
    end

    add_index :accounts, :username, unique: true
    add_index :accounts, :user_id, unique: true
  end
end
