require 'spec_helper'

describe "user profile functionality" do
  context "none logged in user" do
    it "should not be able to edit profile and get redirected to root path" do
      visit edit_profile_path
      expect(current_path).to eq(new_user_session_path)
    end
  end
  context "logged in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "Anmelden"
    end
    it "should be able to edit their profile" do
      visit edit_profile_path
      expect(current_path).to eq(edit_profile_path)
    end
  end
end
