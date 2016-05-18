require 'spec_helper'

describe 'versions management' do
  context 'admin logs in' do
    before do
      # admin logs in
      admin = FactoryGirl.create(:admin) 
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    context 'updates an entry' do
      before do
        entry = FactoryGirl.create(:entry, lemma_in_katakana: 'previous content')
        # edits an entry 
        visit edit_entry_path(entry)
        fill_in 'entry_lemma_in_katakana', with: 'some editing in the field entry_lemma_in_katakana'
        click_button('Speichern')
      end
      it 'sees the changed entry' do
        expect(page).to have_text('some editing in the field entry_lemma_in_katakana')
      end
      it 'gets the right notification with an undo link' do
        expect(page).to have_text("Eintrag erfolgreich editiert. Rückgängig")
        expect(page).to have_link("Rückgängig")      
      end
      it 'clicks the undo link and gets the previous version back' do
        click_link("Rückgängig")      
        expect(page).to have_text('previous content')
      end
    end
  end
end
