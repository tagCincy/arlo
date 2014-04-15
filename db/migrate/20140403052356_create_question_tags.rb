class CreateQuestionTags < ActiveRecord::Migration
  def change
    create_table :question_tags do |t|
      t.belongs_to :question
      t.belongs_to :tag

      t.timestamps
    end

    add_index :question_tags, :question_id
    add_index :question_tags, :tag_id
  end
end
