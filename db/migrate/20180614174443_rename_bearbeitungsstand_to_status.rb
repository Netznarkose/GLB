class RenameBearbeitungsstandToStatus < ActiveRecord::Migration
  def change
    rename_column :entries, :bearbeitungsstand, :status
  end
end
