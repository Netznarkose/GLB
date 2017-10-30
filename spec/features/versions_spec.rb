require 'spec_helper'

describe 'versions management' do
  let(:admin) { FactoryGirl.create(:admin) }
  context 'admin logs in' do
    before do
      login_as_user(admin)
    end
    context 'updates an entry' do
      before do
        entry = FactoryGirl.create(:entry, sanskrit: 'previous content')
        visit edit_entry_path(entry)
        fill_in 'entry_sanskrit', with: 'some editing in the field entry_lemma_in_katakana'
        click_button('Bearbeitung speichern')
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
