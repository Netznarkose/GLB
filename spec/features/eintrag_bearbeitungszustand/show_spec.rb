
require 'spec_helper'

describe 'displays correct state of editing of entries in show' do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:formatted_entry) { FactoryBot.build(:formatted_entry) }
  let!(:unprocessed_entry) { FactoryBot.build(:unprocessed_entry) }

  before do
    login_as_user(admin)
  end
  describe 'admin visits entries#show' do
    context 'when unprocessed' do
      it 'entry is labeled accordingly' do
        unprocessed_entry.save
        visit entry_path(unprocessed_entry)
        expect(page).to have_content('unbearbeitet')
        expect(page).not_to have_content('unformatiert')
        expect(page).not_to have_content('formatiert')
      end
    end
    context 'when formatted' do
      it 'is labeled accordingly' do
        formatted_entry.save
        visit entry_path(formatted_entry)
        expect(page).not_to have_content('unbearbeitet')
      end
    end
  end
end
