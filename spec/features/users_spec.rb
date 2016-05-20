require 'spec_helper'

describe "users management" do
  describe 'authentication' do
    it 'successfull login' do
      FactoryGirl.create(:user, email: 'user@example.com', password: 'password') #test setup (place test-data in the test to have all information in place) 
      visit root_path # action
      click_link('Login')
      fill_in "user_email", with: 'user@example.com' 
      fill_in "user_password", with: 'password' 
      click_button('Anmelden')
      expect(page).to have_content("Erfolgreich angemeldet.") # expectation
    end
    it 'unsuccessfull login' do
      visit root_path 
      click_link('Login')
      fill_in "user_email", with: 'user@example.com' 
      fill_in "user_password", with: 'password' 
      click_button('Anmelden')
      expect(page).to have_content("E-Mail-Adresse oder Passwort ist ungültig.")
    end
    it 'logout' do
      FactoryGirl.create(:user, email: 'user@example.com', password: 'password', name: 'user_name') 
      visit new_user_session_path 
      fill_in "user_email", with: 'user@example.com' 
      fill_in "user_password", with: 'password' 
      click_button('Anmelden')
      click_link('user_name')
      click_link "Abmelden" 
      expect(page).to have_content("Erfolgreich abgemeldet.")
    end
  end
  describe 'authorization' do
    it "should not show users list to common user" do
      pending('there is no user sign up functionality')
      click_link "abmelden"
      fill_in "Email", :with => @editor.email
      fill_in "Password", :with => "anything"
      click_button "Sign in"
      visit users_path
      page.should have_content("Access denied!")
    end
  end

  describe "admin can view the users list and change users' role and delete user" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:admin_in_index) { User.first }
    before(:each) do
      visit new_user_session_path
      fill_in "user_email", with: admin.email
      fill_in "user_password", with: admin.password
      click_button('Anmelden')
      @users = User.all
    end
    it "should display users list" do
      visit users_path
      page.should have_content("Alle Mitarbeiter")
    end
    it "should show user's information" do
      visit users_path
      first(:link, 'Anzeigen').click
      page.should have_content("Einträge")
    end
    it "can change user's role" do
      pending('can not click the link status ändern')
      visit users_path
      last(:link, 'Status Ändern').click
      page.should have_content("Status Ändern")

      # select "editor", :from => "user_role"
      # find("#update_user").click
      # admin_in_index.reload
      # expect(admin_in_index.role).to eq('editor')
      # admin_in_index.role.should == "editor"
    end
  end

  describe "user can change his profile" do
    let(:admin) { FactoryGirl.create(:admin) }
    before(:each) do
      visit new_user_session_path
      fill_in "user_email", with: admin.email
      fill_in "user_password", with: admin.password
      click_button('Anmelden')
    end
    it "should show edit page" do
      click_link "#{admin.name}"
      click_link "Profil Bearbeiten"
      page.should have_content("Profil bearbeiten")
      fill_in "Name", :with => "Tim Tom Tam"
      click_button("Speichern")
      admin.reload
      admin.name.should == "Tim Tom Tam"
    end
  end
end
