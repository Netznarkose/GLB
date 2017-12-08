class AddAssignToUserIdAssignToDateToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :assign_to_user_id, :integer
    add_column :entries, :assign_to_date, :date
  end
end
