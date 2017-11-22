require 'spec_helper'

describe Entry do
  let!(:entry) { FactoryBot.create(:entry) }
  let!(:formatted_entry) { FactoryBot.create(:formatted_entry) }
  let!(:unformatted_entry) { FactoryBot.create(:unformatted_entry) }

  describe 'unprocessed?' do
    it 'returns true if translation is nil' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: nil)
      expect(unprocessed_entry.unprocessed?).to be(true)
    end
    it 'returns true if translation hold only the string "leer"' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: 'leer')
      expect(unprocessed_entry.unprocessed?).to be(true)
    end

    it 'returns true if translation matches a regex' do
      uebersetzung = "x0273_04\n\n\n\n\nN\n\nSBDJ 273 : 4\n\nLemma\n\n"
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: uebersetzung)
      expect(unprocessed_entry.unprocessed?).to be(true)
    end
    it 'returns false if entry is formatted' do
      expect(formatted_entry.unprocessed?).to be(false)
    end
    it 'returns false if entry is unformatted' do
      expect(unformatted_entry.unprocessed?).to be(false)
    end
  end

  # describe 'unrevised?' do
  #   it 'returns true if translation matches a specific regex' do
  #     expect(unrevised_entry.unrevised_translation?).to be(true)
  #   end
  #   it 'returns false if translation does not match a specific regex' do
  #     expect(formatted_entry.unrevised_translation?).to be(false)
  #   end
  # end

  it 'creates a new instance of an entry given valid attributes' do
    expect(entry).to be_persisted
    expect(entry).to be_valid
  end

  it 'is invalid without kennzahl' do
    entry.kennzahl = nil
    expect(entry.valid?).to be(false)
  end

  it 'is invalid when no field of the group
  lemma_schreibungen_und_aussprachen is filled out' do
    entry.japanische_umschrift = ''
    expect(entry.valid?).to be(false)
    expect(entry.errors.messages[:base].first).to eq('Mindestens '\
                                                     "ein Feld der Gruppe \'Lemma-Schreibungen und -Aussprachen\' "\
                                                     "muss ausgefüllt sein!")
  end
  it 'is valid when at least on field of the group
  lemma_schreibungen_und_aussprachen is filled out' do
    entry.japanische_umschrift = ''
    entry.kanji = 'kanji'
    expect(entry.valid?).to be(true)
  end
  it 'is invalid when no field of the group
  uebersetzungen_quellenangaben_literatur_und_ergaenzungen is filled out' do
    entry.deutsche_uebersetzung = ''
    expect(entry.valid?).to be(false)
    expect(entry.errors.messages[:base].first).to eq('Mindestens ein Feld '\
                                                     "der Gruppe \'Uebersetzungen , Quellenangaben, Literatur und "\
                                                     "Ergaenzungen\' muss ausgefüllt sein!")
  end
  it 'is valid when at least one field of the
  group uebersetzungen_quellenangaben_literatur_und_ergaenzungen
  is filled out' do
    entry.deutsche_uebersetzung = ''
    entry.uebersetzung = 'fernfahrer'
    expect(entry.valid?).to be(true)
  end
end
