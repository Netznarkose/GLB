require 'spec_helper'

RSpec.describe Search, type: :concern do
  let(:entry) { create(:entry) }
  
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
end
