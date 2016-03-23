require 'spec_helper'

describe "users management api" do
  describe "login, logout and sign up" do
    let(:user) { FactoryGirl.create(:user) }
    it "should sign in user before displaying dashboard and sign out user" do
      visit new_user_session_path 
      page.should have_content("Anmelden")
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button('Anmelden')
      page.should have_content("Erfolgreich angemeldet.")
      click_link "Abmelden" 
      page.should have_content("Anmelden")
    end
    it "should sign up user" do
      pending('there is no sign up functionality')
      visit root_path
      page.should have_content("Sign up")
      click_link "Sign up"
      fill_in "Name", :with => "admin"
      fill_in "Email", :with => "admin@admin.de"
      find("#user_password").set("password")
      find("#user_password_confirmation").set("password")
      click_button "Sign up"
      page.should have_content("Welcome! You have signed up successfully.")
    end
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
