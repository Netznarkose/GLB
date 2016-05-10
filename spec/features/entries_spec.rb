require 'spec_helper'

describe 'entries management api' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:entry) { FactoryGirl.create(:entry) }
  context 'guest visits page' do
    it 'and gets to entries-index' do
      visit root_path
      expect(page).to have_content('Das Große Lexikon des Buddhismus')
    end
  end
  context 'admin logs in' do
    before do
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
      before do
        visit edit_entry_path(entry)
        fill_in 'entry_lemma_in_katakana', with: 'some changes in the entry'
        click_button('Speichern')
      end
      it 'edits an entry' do
        expect(page).to have_content('some changes in the entry')
      end
      it 'gets the right flash-message after editing' do #Bug #4
        expect(page).to have_content('Eintrag erfolgreich editiert')
      end
      it 'clicks the undo link after editing and gets redirected to previous version' do #Bug #5
        pending('Todo')
        raise
      end
    end
  end
  # context 'editor logs in' do
  #   before do
  #     visit new_user_session_path
  #     fill_in 'user_email', with: editor.email
  #     fill_in 'user_password', with: editor.password
  #     click_button('Anmelden')
  #   end
  #   describe 'editor creates an entry' do
  #     before do
  #       visit new_entry_path
  #       fill_in 'kennzahl', with: '666'
  #       click_button('Speichern')
  #     end
  #     it 'shows the right error-message' do #Bug #4
  #       pending('I do not get an editor logged in')
  #       expect(page).to have_content('as editor you are not allowed to create entries for other users')
  #       save_and_open_page
  #     end
  #   end
  # end
end
