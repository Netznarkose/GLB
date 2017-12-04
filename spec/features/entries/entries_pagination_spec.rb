require 'spec_helper'

describe 'entries index pagination' do
  let(:admin) { FactoryBot.create(:admin) }

  describe 'admin visits index' do
    before do
      login_as_user(admin)
      100.times { FactoryBot.create(:entry) }
      visit entries_path
    end
    it 'sees pagination navigation' do
      expect(page.all('ul.pagination').count).to eq(2)
    end
    it 'is able to navigate between pages' do
      expect(page).to have_link('Letzte')
      first(:link, 'Letzte').click
      expect(page).not_to have_link('Letzte')
    end
  end
end
