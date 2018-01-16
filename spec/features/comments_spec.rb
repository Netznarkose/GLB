require 'spec_helper'

describe 'comments management' do
  describe 'admin write a comment' do
    let(:entry) { FactoryBot.create(:entry) }
    let(:comment) { FactoryBot.create(:comment, entry_id: entry.id) }
    let(:admin) { FactoryBot.create(:admin) }
    before do
      comment.save
      login_as_user(admin)
    end
    it 'edits a comment' do
      comment.update(comment: 'previous comment content')
      visit entry_path(entry)
      within ".capyb" do
        click_link("Bearbeiten")
      end
      fill_in 'comment_comment', with: 'new comment-content'
      click_button('Speichern')
      expect(page).to have_content('new comment-content')
    end
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
      expect(page).to have_content('Kommentar darf nicht leer sein!')
    end
    it 'deletes a comment' do
      visit entry_path(entry)
      within ".capyb" do
        click_link("Löschen")
      end
      expect(page).not_to have_content(comment.comment)
    end
  end
end
