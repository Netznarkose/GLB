
require 'spec_helper'

describe 'DSGVO' do
  context 'as guest visiting root_url' do
    before do
      visit root_path
    end
    it 'routes me to starting page' do
      expect(page).to have_content('Projektbeschreibung')
      expect(page).to have_content('Allgemeine Datenschutzerklärung')
    end

    it 'provides links' do
      page.should have_link('Zum Login')
      page.should have_link('Weiter als Gast')
    end
  end
end
