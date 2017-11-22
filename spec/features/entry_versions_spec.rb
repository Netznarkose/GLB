require 'spec_helper'

describe 'entry_versions management' do
  let(:admin) { FactoryBot.create(:admin) }
  let(:entry) { FactoryBot.create(:entry) }

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
      it 'visits version index and sees two versions of entry' do
        visit entry_versions_path(entry)
        expect(page).to have_css('h6', count: 2)
      end
      it 'visits current version and sees respective changes' do
        visit entry_versions_path(entry)
        click_link('Aktuelle Version')
        expect(page).to have_content('1:3')
      end
      it 'visits first version and sees respective changes' do
        visit entry_versions_path(entry)
        click_link('Version: 1')
        expect(page).to have_content('1:2')
      end
      it 'visits second version and sees respective changes' do
        visit entry_versions_path(entry)
        click_link('Version: 2')
        expect(page).to have_content('1:1')
      end
    end
  end
end
