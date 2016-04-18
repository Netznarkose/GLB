require 'spec_helper'

describe 'entries management api' do
  describe 'admin writes an entry' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:entry) { FactoryGirl.create(:entry) }
    # let(:comment) { FactoryGirl.create(:comment) }
    before(:each) do
      # admin logs in
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    it 'displays a certain entry' do
      visit entry_path(entry)
      expect(page).to have_content('Scan SBDJ')
    end
    #edit
    it 'edits an entry' do
      visit edit_entry_path(entry)
      fill_in 'entry_lemma_in_katakana', with: 'some changes in the comment'
      click_button('Speichern')
      expect(page).to have_content('some changes in the comment')
    end
  end
end
