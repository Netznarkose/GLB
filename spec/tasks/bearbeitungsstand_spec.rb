require 'spec_helper'

describe 'rake db:label_bearbeitungsstand', type: :task do
  let(:entry)                   { build(:entry) }
  let(:unprocessed_entry)       { build(:unprocessed_entry, bearbeitungsstand: nil) }
  let(:formatted_entry)         { build(:formatted_entry, bearbeitungsstand: nil) }
  let(:unformatted_entry)       { build(:unformatted_entry, bearbeitungsstand: nil) }
  let(:deprecated_syntax_entry) { build(:deprecated_syntax_entry, bearbeitungsstand: nil) }
  let(:already_labeled_entry)   { build(:entry, bearbeitungsstand: 'formatiert', uebersetzung: nil) }

  context 'general' do
    it 'preloads the Rails environment' do
      expect(task.prerequisites).to include 'environment'
    end

    it 'runs gracefully' do
      expect { task.execute }.not_to raise_error
    end
  end

  context 'entries' do
    it 'labels an unprocessed entry as unbearbeitet' do
      unprocessed_entry.save
      task.execute
      unprocessed_entry.reload
      expect(unprocessed_entry.bearbeitungsstand).to eq('unbearbeitet')
    end

    it 'labels a formatted entry as formatiert' do
      formatted_entry.save
      task.execute
      formatted_entry.reload
      expect(formatted_entry.bearbeitungsstand).to eq('formatiert')
    end

    it 'labels a unformatted entry as unformatiert' do
      unformatted_entry.save
      task.execute
      unformatted_entry.reload
      expect(unformatted_entry.bearbeitungsstand).to eq('unformatiert')
    end

    it 'labels an entry that contains deprecated syntax as Code veraltet' do
      deprecated_syntax_entry.save
      task.execute
      deprecated_syntax_entry.reload
      expect(deprecated_syntax_entry.bearbeitungsstand).to eq('Code veraltet')
    end

    it 'does not overwrites labels that where already set' do
      already_labeled_entry.save
      expect(already_labeled_entry.bearbeitungsstand).to eq('formatiert')
      task.execute
      already_labeled_entry.reload
      expect(already_labeled_entry.bearbeitungsstand).to eq('formatiert')
      expect(already_labeled_entry.bearbeitungsstand).not_to eq('unbearbeitet')
    end
  end
end
