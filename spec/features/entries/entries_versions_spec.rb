require 'spec_helper'

describe 'entry_versions management' do
  let(:admin) { create(:admin) }
  let(:entry) { create(:entry) }

  context 'admin logs in' do
    before do
      login_as_user(admin)
    end
    context 'edits an entry two times' do
      before do
        visit edit_entry_path(entry)
        fill_in 'entry_kennzahl', with: '1:2'
        click_button('Speichern')
        visit edit_entry_path(entry)
        fill_in 'entry_kennzahl', with: '1:3'
        click_button('Speichern')
      end
      it 'visits version index and sees current- plus two versions of entry' do
        visit entry_versions_path(entry)
        expect(page.all('tr > td').count).to eq(8)
      end
      it 'visits current version and sees respective changes' do
        visit entry_versions_path(entry)
        click_link('Anzeigen', match: :first)
        expect(page).to have_content('1:3')
      end
      it 'visits first version and sees respective changes' do
        visit entry_version_path(entry.versions[1].item_id, entry.versions[1].id)
        expect(page).to have_content('1:1')
      end
      it 'visits second version and sees respective changes' do
        visit entry_version_path(entry.versions[2].item_id, entry.versions[2].id)
        expect(page).to have_content('1:2')
      end
    end
  end
end
