class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :assigned_from_user
      t.integer :assigned_to_user
      t.date :assigned_at_date
      t.date :assigned_to_date
      t.integer :assigned_entry

      t.timestamps null: false
    end
  end
end
