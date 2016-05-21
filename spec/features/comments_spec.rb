require 'spec_helper'

describe 'comments management' do
  describe 'admin write a comment' do
    let(:entry) { FactoryGirl.create(:entry) }
    let(:comment) { FactoryGirl.create(:comment) }
    before do
      admin = FactoryGirl.create(:admin)
      visit new_user_session_path
      fill_in 'user_email', with: admin.email
      fill_in 'user_password', with: admin.password
      click_button('Anmelden')
    end
    it 'edits a comment' do
      entry = FactoryGirl.create(:entry)
      comment = FactoryGirl.create(:comment, comment: 'previous comment-content', entry_id: entry.id)
      visit entry_path(entry)
      # edits the comment
      within('.down_comments') do
        click_link('Bearbeiten')
      end
      within('.down_comments') do
      end
      # fill_in 'comment_comment', with: 'new comment-content'
      fill_in '#comment_comment', with: 'fucking do it'
      save_and_open_page
      click_button('Speichern')
      expect(page).to have_content('new comment-content')
    end
    #create
    it 'writes and saves a comment' do
      visit entry_path(entry)
      fill_in 'comment_comment', with: comment.comment
      click_button('Speichern')
      expect(page).to have_content(comment.comment)
    end
    it 'displays an error-message when user
    enters invalid input' do
      visit entry_path(entry)
      fill_in 'comment_comment', with: ''
      click_button('Speichern')
      expect(page).to have_content('The form contains 1 error.')
    end
    #destroy
    it 'deletes a comment' do
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
