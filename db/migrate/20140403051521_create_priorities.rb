class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.string :name
      t.integer :display_order

      t.timestamps
    end
  end
end
