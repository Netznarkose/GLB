require 'spec_helper'

describe 'user_entries pagination' do
  let(:admin) { create(:admin) }

  describe 'admin visits user entries' do
    before do
      login_as_user(admin)
      100.times { create(:entry, user_id: admin.id) }
      visit user_entries_path(admin.id)
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
