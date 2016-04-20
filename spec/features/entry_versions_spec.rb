require 'spec_helper'

describe 'entry_versions management api' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:entry) { FactoryGirl.create(:entry) }

  before(:each) do
    # admin logs in
    visit new_user_session_path
    fill_in 'user_email', with: admin.email
    fill_in 'user_password', with: admin.password
    click_button('Anmelden')
  end

  before(:each) do
  # edits an entry two times' do
    visit edit_entry_path(entry)
    fill_in 'entry_lemma_in_katakana', with: 'edit for the first time'
    click_button('Speichern')
    visit edit_entry_path(entry)
    fill_in 'entry_lemma_in_katakana', with: 'edit for the second time'
    click_button('Speichern')
  end
    #edit
  it 'admin visits the version index' do
    visit entry_entry_versions_path(entry)
    expect(page).to have_content('Versions Index')
  end
  it 'admin visits a version show template' do
    visit entry_entry_versions_path(entry)
    click_link('Version: 1')
    expect(page).to have_content('Kennungsdaten')
  end
end
