require 'spec_helper'

describe 'entries index counter' do
  let(:admin) { FactoryBot.create(:admin) }

  describe 'admin visits index' do
    before do
      login_as_user(admin)
      10.times { FactoryBot.create(:entry) }
      visit entries_path
    end
    context 'without search or filtering' do
      it 'gets the right amount of entries displayed' do
        expect(page.find('span.badge').text).to eq('10')
      end
    end
    context 'with filtering' do
      it 'gets the right amount of entries displayed' do
        FactoryBot.create(:entry, bearbeitungsstand: 'unbearbeitet')
        click_button 'Felder Auswahl'
        click_link 'Unbearbeitet'
        expect(page.find('span.badge').text).to eq('1')
      end
    end
    context 'with searching' do
      it 'gets the right amount of entries displayed' do
        FactoryBot.create(:entry, uebersetzung: 'xyz23')
        fill_in 'search', with: 'xyz23'
        click_button 'Los'
        expect(page.find('span.badge').text).to eq('1')
      end
    end
  end
end
