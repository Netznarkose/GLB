require 'spec_helper'

describe "users management api" do
  describe "login, logout and sign up" do
    it "should sign in user before displaying dashboard and sign out user" do
      visit root_path
      page.should have_content("Sign in")
      user = FactoryGirl.create(:editor)
      fill_in "Email", :with => user.email
      fill_in "Password", :with => "anything"
      click_button "Sign in"
      page.should have_content("Signed in successfully.")
      click_link "abmelden"
      page.should have_content("Sign in")
    end
    it "should sign up user" do
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
  end

  describe "admin can view the users list and change users' role and delete user" do
    before(:each) do
      @editor = FactoryGirl.create(:editor)
      admin = FactoryGirl.create(:admin)
      visit root_path
      fill_in "Email", :with => admin.email
      fill_in "Password", :with => "anything"
      click_button "Sign in"
    end
    it "should display users list" do
      visit users_path
      page.should have_content("Listing users")
    end
    it "should show user's information" do
      visit users_path
      first(:link, 'Show').click
      page.should have_content("Status")
    end
    it "can change user's role" do
      visit users_path
      first(:link, 'Show').click
      select "admin", :from => "user_role"
      find("#update_user").click
      @editor.reload
      @editor.role.should == "admin"
    end
    it "should not show users list to common user" do
      click_link "abmelden"
      fill_in "Email", :with => @editor.email
      fill_in "Password", :with => "anything"
      click_button "Sign in"
      visit users_path
      page.should have_content("Access denied!")

    end
  end

  describe "user can change his profile" do
    before(:each) do
      @user = FactoryGirl.create(:editor)
      visit root_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "anything"
      click_button "Sign in"
    end
    it "should show edit page" do
      click_link "Konto"
      page.should have_content("Update profile")
      fill_in "Name", :with => "Tim Tom Tam"
      find("#update_user").click
      @user.reload
      @user.name.should == "Tim Tom Tam"
    end
  end



end
