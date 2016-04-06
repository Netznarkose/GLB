require 'spec_helper'

describe 'comments management api' do
  describe 'admin write a comment' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:entry) { FactoryGirl.create(:entry) }
    let(:comment) { FactoryGirl.create(:comment) }
    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    it 'should display a certain Entry' do
      visit entry_path(entry)
      expect(page).to have_content('Scan SBDJ')
    end
    it 'should be able to write and save a comment' do
      visit entry_path(entry)
      fill_in 'comment_comment', with: comment.comment
      click_button('Speichern')
      expect(page).to have_content(comment.comment)
    end
    it 'should see an error message when tries
    to save a comment without text' do
      visit entry_path(entry)
      fill_in 'comment_comment', with: ''
      click_button('Speichern')
      expect(page).to have_content('The form contains 1 error.')
    end
    it 'should be able to edit  a comment' do
      # writes a comment to be able to edit it
      visit entry_path(entry)
      fill_in 'comment_comment', with: comment.comment
      click_button('Speichern')
      # edits the comment
      within('.down_comments') do
        click_link('Bearbeiten')
      end
      fill_in 'comment_comment', with: 'some changes in the comment'
      click_button('Speichern')
      expect(page).to have_content('some changes in the comment')
    end
    it 'should be able to delete a comment' do
      # writes a comment to be able to delete it
      visit entry_path(entry)
      fill_in 'comment_comment', with: comment.comment
      click_button('Speichern')
      # deletes the comment
      within('.down_comments') do
        click_link('Löschen')
      end
      expect(page).not_to have_content(comment.comment)
    end
  end
end
