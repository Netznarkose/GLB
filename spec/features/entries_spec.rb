require 'spec_helper'

describe 'entries management' do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:entry) { FactoryGirl.create(:entry) }

  describe 'entries authorization' do
    context 'authenticated user' do
      before do
        user = FactoryGirl.create(:user)
        visit new_user_session_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button('Anmelden')
      end
      context 'visits the entries index with a valid entry' do
        before do
          FactoryGirl.create(:entry, uebersetzung: 'funky translation')
          visit entries_path
        end
        it 'gets the template title' do
          expect(page).to have_content('Das Große Lexikon des Buddhismus')
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
          expect(page).to have_content('Das Große Lexikon des Buddhismus')
        end
        it "but does not sees the field 'uebersetzungsfeld'" do
          expect(page).not_to have_content('funky translation')
        end
      end
    end
    context 'unpublished entries' do
      before do
        user = FactoryGirl.create(:user, role: 'admin')
        visit new_user_session_path
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button('Anmelden')
        unpublished_entry = FactoryGirl.create(:entry, freigeschaltet: false)
        visit entry_path(unpublished_entry)
      end
      it 'show the scans' do
        expect(page).to have_selector('#page0')
      end
    end
    context 'published entries' do
      before do
        published_entry = FactoryGirl.create(:entry, freigeschaltet: true)
        visit entry_path(published_entry)
      end
      it 'do not show the scans' do
        expect(page).not_to have_content('Scan')
      end
    end
  end
end
