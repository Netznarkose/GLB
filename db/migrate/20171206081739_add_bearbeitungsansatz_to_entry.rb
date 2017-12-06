class AddBearbeitungsansatzToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :bearbeitungsansatz, :string
  end
end
