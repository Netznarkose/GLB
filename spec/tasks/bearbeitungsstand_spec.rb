require 'spec_helper'

describe 'rake set_entry_bearbeitungsstand', type: :task do
  let(:rake_task_user) { FactoryBot.build(:admin, email: 'rake@user.com') }
  let(:entry) { FactoryBot.build(:entry) }
  let(:unprocessed_entry) { FactoryBot.build(:unprocessed_entry, bearbeitungsstand: nil) }
  let(:formatted_entry) { FactoryBot.build(:formatted_entry, bearbeitungsstand: nil) }
  let(:unformatted_entry) { FactoryBot.build(:unformatted_entry, bearbeitungsstand: nil) }
  let(:deprecated_syntax_entry) { FactoryBot.build(:deprecated_syntax_entry, bearbeitungsstand: nil) }

  context 'general' do
    it 'preloads the Rails environment' do
      expect(task.prerequisites).to include 'environment'
    end

    it 'runs gracefully' do
      expect { task.execute }.not_to raise_error
    end
  end

  context 'user' do
    it 'creates an rake-task user if it does not exist' do
      expect { task.execute }.to change(User, :count).by(1)
    end

    it 'does not create a rake-task user if user exist' do
      rake_task_user.save
      expect { task.execute }.to change(User, :count).by(0)
    end
  end

  context 'entries' do
    it 'labels an unprocessed entry as unbearbeitet' do
      unprocessed_entry.save
      task.execute
      expect(Entry.last.bearbeitungsstand).to eq('unbearbeitet')
    end

    it 'labels a formatted entry as formatiert' do
      formatted_entry.save
      task.execute
      expect(Entry.last.bearbeitungsstand).to eq('formatiert')
    end

    it 'labels a unformatted entry as unformatiert' do
      unformatted_entry.save
      task.execute
      expect(Entry.last.bearbeitungsstand).to eq('unformatiert')
    end

    it 'labels an entry that contains deprecated syntax as Code veraltet' do
      deprecated_syntax_entry.save
      task.execute
      expect(Entry.last.bearbeitungsstand).to eq('Code veraltet')
    end

    it 'does not overwrites labels that where already set' do
      entry.update(bearbeitungsstand: 'formatiert', uebersetzung: nil)
      task.execute
      expect(Entry.last.bearbeitungsstand).to eq('formatiert')
      expect(Entry.last.bearbeitungsstand).not_to eq('unbearbeitet')
    end
  end
end
