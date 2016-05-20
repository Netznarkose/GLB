require 'spec_helper'

describe 'entries management' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:entry) { FactoryGirl.create(:entry) }

  describe 'entries authorization' do
    context 'authenticated user' do
        before do
          FactoryGirl.create(:user, email: 'user@example.com', password: 'password', name: 'user_name') 
          visit new_user_session_path 
          fill_in "user_email", with: 'user@example.com' 
          fill_in "user_password", with: 'password' 
          click_button('Anmelden')
        end
      context 'visits the entries index with a valid entry' do
        before do
          FactoryGirl.create(:entry, uebersetzung: 'funky translation') 
          visit entries_path
        end
        it 'gets the template title' do
          expect(page).to have_content("Das Große Lexikon des Buddhismus")
        end
        it "and sees the field 'uebersetzungsfeld' of the entry" do
          expect(page).to have_content('funky translation')
        end
      end
    end
    context 'non-logged in user' do
      context 'visits the entries index with a valid entry' do
        before do
          FactoryGirl.create(:entry, uebersetzung: 'funky translation') 
          visit entries_path
        end
        it 'gets the template title' do
          expect(page).to have_content("Das Große Lexikon des Buddhismus")
        end
        it "but does not sees the field 'uebersetzungsfeld'" do
          expect(page).not_to have_content('funky translation')
        end
      end
    end
    context 'published entries' do
      before do
        published_entry = FactoryGirl.create(:published_entry)
        visit edit_entry_path(published_entry)
      end
      it 'do not show the scans' do
      end
    end
  end
end
