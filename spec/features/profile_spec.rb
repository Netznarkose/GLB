require 'spec_helper'

describe 'user profile management' do
  context 'non-logged in user' do
    it 'can not visit edit-template and get redirected to root path' do
      visit edit_profile_path
      expect(current_path).to eq(root_path)
    end
  end
  context 'logged in users' do
    let(:user) { FactoryBot.create(:user) }
    before do
      login_as_user(user)
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
      expect(page).to have_content('Profil erfolgreich bearbeitet')
      expect(page).to have_field('user_name', with: 'Michael Jackson')
      expect(page).to have_field('user_email', with: 'michael_jackson@gmail.com')
    end
    it 'should get an error-message when input is not valid' do
      visit edit_profile_path
      fill_in 'user_name', with: 'Michael Jackson'
      fill_in 'user_email', with: ''
      click_button('Speichern')
      expect(page).to have_content('The form contains 1 error.')
    end
  end
end
