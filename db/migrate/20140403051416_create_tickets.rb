class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject, null: false
      t.text :content, null: false
      t.belongs_to :account
      t.belongs_to :assignee
      t.belongs_to :category
      t.belongs_to :status
      t.belongs_to :priority

      t.timestamps
    end

    add_index :tickets, :account_id
    add_index :tickets, :assignee_id
    add_index :tickets, :category_id
    add_index :tickets, :status_id
    add_index :tickets, :priority_id
  end
end
