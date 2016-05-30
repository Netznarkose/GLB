class AddTableToAbweichendeKennzahlToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :abweichende_kennzahl, :string
    add_column :entries, :japanischer_quelltext, :string
    add_column :entries, :japanischer_quelltext_bearbeitungsstand, :string
  end
end
