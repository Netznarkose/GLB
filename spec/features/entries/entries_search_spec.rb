require 'spec_helper'

describe 'sort index' do
  let(:admin)                   { create(:admin) }
  let(:formatted_entry)         { build(:entry, status: 'formatiert') }
  let(:unformatted_entry)       { build(:entry, status: 'unformatiert') }
  let(:unprocessed_entry)       { build(:entry, status: 'unbearbeitet') }
  let(:deprecated_syntax_entry) { build(:entry, status: 'Code veraltet') }

  before do
    login_as_user(admin)
  end
  describe 'admin filters' do
    before do
      formatted_entry.save
      unformatted_entry.save
      unprocessed_entry.save
      deprecated_syntax_entry.save
    end
    context 'formatted entries' do
      it 'only shows formatted entries' do
        visit entries_path
        click_link 'Formatiert'
        expect(page.find('span.label-success').text).to eq('formatiert')
        ['danger', 'info', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'unformatted entries' do
      it 'only shows unformatted entries' do
        visit entries_path
        click_link 'Unformatiert'
        expect(page.find('span.label-info').text).to eq('unformatiert')
        ['danger', 'success', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'unprocessed entries' do
      it 'only shows unprocessed entries' do
        visit entries_path
        click_link 'Unbearbeitet'
        expect(page.find('span.label-danger').text).to eq('unbearbeitet')
        ['info', 'success', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'deprecated syntax entries' do
      it 'only shows entries with deprecated syntax' do
        visit entries_path
        click_link 'Code Veraltet'
        expect(page.find('span.label-warning').text).to eq('Code veraltet')
        ['info', 'success', 'danger'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
  end
  describe 'sort' do
    before do
      create(:entry, id: 3, status: 'unbearbeitet', japanische_umschrift: 'Aalhaus')
      create(:entry, id: 1, status: 'unbearbeitet', japanische_umschrift: 'Rote Flora')
      create(:entry, id: 2, status: 'unbearbeitet', japanische_umschrift: 'Zeise')
    end
    describe 'it sorts entries' do
      it 'in ascending order' do
        visit entries_path
        click_button 'Felder Auswahl'
        click_link 'Unbearbeitet'
        expect(all('strong')[0].text).to eq('Aalhaus')
        expect(all('strong')[4].text).to eq('Zeise')
      end
      it 'in descending order' do
        visit entries_path
        click_link 'Unbearbeitet (rev)'
        expect(all('strong')[0].text).to eq('Zeise')
        expect(all('strong')[4].text).to eq('Aalhaus')
      end
    end
  end
end
