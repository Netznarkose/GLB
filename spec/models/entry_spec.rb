require 'spec_helper'

RSpec.describe Entry, type: :model do
  let(:entry) { create(:entry) }
  let(:assignment) { create(:assignment) }

  describe 'general' do
    it 'creates a new instance of an entry given valid attributes' do
      expect(entry).to be_persisted
      expect(entry).to be_valid
    end
  end

  describe '#search' do
    it 'returns search result for specific field' do
      entry.update(kanji: 'foo')
      expect(Entry.search('all', 'foo').first).to eq(entry)
      expect(Entry.search('foo').first).to eq(entry)
      expect(Entry.search('kanji', 'foo').first).to eq(entry)
      expect(Entry.search('kanji', 'bar').first).not_to eq(entry)
      expect(Entry.search('uebersetzung', 'foo').first).not_to eq(entry)
    end
    context 'bearbeitungsstand' do
      it 'returns search result for bearbeitungsstand' do
        entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'foo')
        expect(Entry.search('all', 'foo').first).to eq(entry)
        expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
        expect(Entry.search('formatiert', 'foo').first).not_to eq(entry)
      end
      it 'returns search case-insensitive result for bearbeitungsstand' do
        entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'Foo')
        expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
      end
      it 'returns only matches that starts with search pattern' do
        entry.update(bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'foo')
        second_entry = create(:entry, bearbeitungsstand: 'unbearbeitet', japanische_umschrift: 'barfoo')
        expect(Entry.search('unbearbeitet', 'foo').count).to eq(1)
        expect(Entry.search('unbearbeitet', 'foo').first).to eq(entry)
      end
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
