require 'spec_helper'

describe Entry do
  let!(:entry) { FactoryBot.create(:entry) }
  let!(:formatted_entry) { FactoryBot.create(:formatted_entry) }
  let!(:unformatted_entry) { FactoryBot.create(:unformatted_entry) }
  let!(:unprocessed_entry) { FactoryBot.create(:unprocessed_entry) }

  describe '#search' do
    it 'returns search result for specific field' do
      entry.update(kanji: 'foo')
      expect(Entry.search('all', 'foo').first).to eq(entry)
      expect(Entry.search('foo').first).to eq(entry)
      expect(Entry.search('kanji', 'foo').first).to eq(entry)
      expect(Entry.search('kanji', 'bar').first).not_to eq(entry)
      expect(Entry.search('uebersetzung', 'foo').first).not_to eq(entry)
    end
    it 'returns search result for bearbeitungsstand' do
      entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'foo')
      expect(Entry.search('all', 'foo').first).to eq(entry)
      expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
      expect(Entry.search('formatiert', 'foo').first).not_to eq(entry)
   end
  end
  describe 'formatted?' do
    it 'returns true if entry is formatted' do
      expect(formatted_entry.formatted?).to be(true)
    end
    it 'returns false if entry is unformatted' do
      expect(unformatted_entry.formatted?).to be(false)
    end
    it 'returns false if entry is unprocessed' do
      expect(unprocessed_entry.formatted?).to be(false)
    end
  end
  describe 'unformatted?' do
    it 'returns true if entry is unformatted' do
      expect(unformatted_entry.unformatted?).to be(true)
    end
    it 'returns false if entry is formatted' do
      expect(formatted_entry.unformatted?).to be(false)
    end
    it 'returns false if entry is unprocessed' do
      expect(unprocessed_entry.unformatted?).to be(false)
    end
  end
  describe 'unprocessed?' do
    it 'returns true if translation is nil' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: nil)
      expect(unprocessed_entry.unprocessed?).to be(true)
    end
    it 'returns true if translation is empty' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: "")
      expect(unprocessed_entry.unprocessed?).to be(true)
    end
    it 'returns true if translation hold only the string "leer"' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: 'leer')
      expect(unprocessed_entry.unprocessed?).to be(true)
    end

    it 'returns true if translation hold only the string "Leer" wrapped in html-tags' do
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: "<p>leer</p>\r\n")
      expect(unprocessed_entry.unprocessed?).to be(true)
    end

    it 'returns false if the word "leer" occurs in an unformatted or formatted entry' do
      uebersetzung = unformatted_entry.uebersetzung
      uebersetzung.concat 'leer'
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: uebersetzung)
      expect(unprocessed_entry.unprocessed?).to be(false)
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
