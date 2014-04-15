class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.integer :display_order

      t.timestamps
    end
  end
end
