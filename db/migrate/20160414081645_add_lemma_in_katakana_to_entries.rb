class AddLemmaInKatakanaToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :lemma_in_katakana, :string
    add_column :entries, :lemma_in_lateinbuchstaben, :string
  end
end
