class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content, null: false
      t.belongs_to :account
      t.belongs_to :question

      t.timestamps
    end

    add_index :answers, :account_id
    add_index :answers, :question_id
  end
end
