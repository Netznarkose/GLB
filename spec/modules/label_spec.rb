require 'spec_helper'

describe Label do
  let!(:entry) { FactoryBot.create(:entry) }
  let!(:formatted_entry) { FactoryBot.create(:formatted_entry) }
  let!(:unformatted_entry) { FactoryBot.create(:unformatted_entry) }
  let!(:unprocessed_entry) { FactoryBot.create(:unprocessed_entry) }

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
      unprocessed_entry = FactoryBot.create(:entry, uebersetzung: '')
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
end
