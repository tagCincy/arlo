class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :public, default: true
      t.belongs_to :account
      t.belongs_to :group
      t.belongs_to :accepted_answer

      t.timestamps
    end

    add_index :questions, :account_id
    add_index :questions, :group_id
    add_index :questions, :accepted_answer_id
  end
end
