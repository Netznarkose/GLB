require 'spec_helper'

describe 'user profile management' do
  context 'non-logged in user' do
    it 'can not visit edit-template and get redirected to root path' do
      visit edit_profile_path
      expect(current_path).to eq(root_path)
    end
  end
  context 'logged in users' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button('Anmelden')
    end
    it 'should be able to visit their profile page' do
      visit edit_profile_path
      expect(current_path).to eq(edit_profile_path)
    end
    it 'should be able to edit their profile' do
      visit edit_profile_path
      fill_in 'user_name', with: 'Michael Jackson'
      fill_in 'user_email', with: 'michael_jackson@gmail.com'
      click_button('Speichern')
      expect(current_path).to eq(edit_profile_path)
      expect(page).to have_content('profile updated')
      expect(page).to have_field('user_name', with: 'Michael Jackson')
      expect(page).to have_field('user_email', with: 'michael_jackson@gmail.com')
    end
    it 'should get an error-message when input is not valid' do
      visit edit_profile_path
      fill_in 'user_name', with: 'Michael Jackson'
      fill_in 'user_email', with: ''
      click_button('Speichern')
      expect(page).to have_content('Access denied!')
    end
  end
end
