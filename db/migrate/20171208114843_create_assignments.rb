class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :creator_id
      t.integer :recipient_id
      t.date :from_date
      t.date :to_date
      t.integer :entry_id

      t.timestamps null: false
    end
  end
end
