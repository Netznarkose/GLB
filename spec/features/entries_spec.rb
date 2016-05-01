require 'spec_helper'

describe 'entries management api' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:entry) { FactoryGirl.create(:entry) }
  before(:each) do
    # admin logs in
    visit new_user_session_path
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_button('Anmelden')
  end
  it 'displays the entry-show template' do
    visit entry_path(entry)
    expect(page).to have_content('Scan SBDJ')
  end
  describe 'user edits an entry' do
    #edit
    it 'edits an entry' do
      visit edit_entry_path(entry)
      fill_in 'entry_lemma_in_katakana', with: 'some changes in the entry'
      click_button('Speichern')
      expect(page).to have_content('some changes in the entry')
    end
    it 'gets the right flash-message after editing' do #Bug #4
      visit edit_entry_path(entry)
      fill_in 'entry_lemma_in_katakana', with: 'some changes in the comment'
      click_button('Speichern')
      expect(page).to have_content('Eintrag erfolgreich editiert')
    end
    it 'clicks the undo link after editing and gets redirected to previous version' do #Bug #5
      pending('Todo')
      raise
    end
  end
end
