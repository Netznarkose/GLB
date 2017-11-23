class AddBearbeitungsstandToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :bearbeitungsstand, :string
  end
end
