# File: spec/tasks/send_invoices_spec.rb
require 'spec_helper'

describe 'rake set_entry_bearbeitungsstand', type: :task do
  let(:rake_task_user) { FactoryBot.build(:admin, email: 'rake@user.com') }
  let(:unprocessed_entry) { FactoryBot.build(:entry, bearbeitungsstand: nil, uebersetzung: nil) }

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
  end
end
