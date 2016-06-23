require 'spec_helper'

describe 'users management' do # check test-descriptions and redundancies between controller-tests
  describe 'authentication' do
    it 'successfull login' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link('Login')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button('Anmelden')
      expect(page).to have_content('Erfolgreich angemeldet.')
    end
    it 'unsuccessfull login' do
      visit root_path
      click_link('Login')
      fill_in 'user_email', with: 'user@example.com'
      fill_in 'user_password', with: 'password'
      click_button('Anmelden')
      expect(page).to have_content("E-Mail-Adresse oder Passwort ist ungültig.")
    end
    it 'logout' do
      user = FactoryGirl.create(:user)
      visit root_path
      click_link('Login')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button('Anmelden')
      click_link(user.name)
      click_link 'Abmelden'
      expect(page).to have_content('Erfolgreich abgemeldet.')
    end
  end
  describe 'authorization' do
    it 'should not show users list to not logged in users' do
      visit users_path
      expect(page).to have_content('Access denied!')
    end
  end

  describe "admin can view the users list and change users' role and delete user" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:admin_in_index) { User.first }
    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    it 'should display users list' do
      visit users_path
      expect(page).to have_content('Alle Mitarbeiter')
    end
    it "should show user's information" do
      visit users_path
      first(:link, 'Anzeigen').click
      expect(page).to have_content('Einträge')
    end
    it "can change user's role" do
      visit users_path
      click_link "Status Ändern"
      select 'Editor', from: 'user_role'
      click_button('Speichern')
      admin_in_index.reload
      expect(admin_in_index.role).to eq('Editor')
    end
  end

  describe 'user can change his profile' do
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    it 'should show edit page' do
      click_link admin.name.to_s
      click_link 'Profil Bearbeiten'
      expect(page).to have_content('Profil bearbeiten')
      fill_in 'Name', with: 'Tim Tom Tam'
      click_button('Speichern')
      admin.reload
      expect(admin.name).to eq('Tim Tom Tam')
    end
  end
end
