require 'spec_helper'

describe 'displays correct state of editing of entries' do
  let!(:formatted_entry) { FactoryGirl.build(:formatted_entry) }
  let!(:unprocessed_entry) { FactoryGirl.build(:unprocessed_entry) }
  let(:admin) { FactoryGirl.build(:admin) }

  describe 'unprocessed entries' do
    before do
      login_as_user(admin)
    end
    context 'when around' do
      it 'gets labeled correctly' do
        unprocessed_entry.save
        visit entries_path
        expect(page).to have_content('Unbearbeitet')
      end
    end
    context 'when not around' do
      it 'do not labeled' do
        formatted_entry.save
        visit entries_path
        expect(page).not_to have_content('Unbearbeitet')
      end
    end
  end
end
