require 'spec_helper'

RSpec.describe Assignment, type: :model do
  let!(:entry) { create(:entry) }
  let!(:assignment) { create(:assignment) }

  describe 'general' do
    it 'creates a new instance of an entry given valid attributes' do
      expect(entry).to be_persisted
      expect(entry).to be_valid
    end
  end

  describe 'validations' do
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
                                                       'muss ausgefüllt sein!')
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

  describe '#search' do
    it 'returns search result for specific field' do
      entry.update(kanji: 'foo')
      expect(Entry.search('alle', 'foo').first).to eq(entry)
      expect(Entry.search('foo').first).to eq(entry)
      expect(Entry.search('kanji', 'foo').first).to eq(entry)
      expect(Entry.search('kanji', 'bar').first).not_to eq(entry)
      expect(Entry.search('uebersetzung', 'foo').first).not_to eq(entry)
    end
    it 'returns search result for bearbeitungsstand' do
      entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'foo')
      expect(Entry.search('alle', 'foo').first).to eq(entry)
      expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
      expect(Entry.search('formatiert', 'foo').first).not_to eq(entry)
    end
    it 'returns search case-insensitive result for bearbeitungsstand' do
      entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'Foo')
      expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
    end
  end
  describe 'destroy_related_assignment' do
    context 'with assignment' do
      before do
        assignment.update(entry_id: entry.id)
      end
      it 'destroys it' do
        expect(Assignment.where(id: assignment.id).first).to eq(assignment)
        entry.destroy_related_assignment
        expect(Assignment.where(id: assignment.id).first).to eq(nil)
      end
    end
    context 'without assignment' do
      it 'does not raise an error' do
        expect{ entry.destroy_related_assignment }.not_to raise_error
      end
    end
  end
end
