require 'spec_helper'

describe 'displays correct state of editing of entries of index' do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:formatted_entry) { FactoryBot.build(:entry, bearbeitungsstand: 'formatiert') }
  let!(:unformatted_entry) { FactoryBot.build(:entry, bearbeitungsstand: 'unformatiert') }
  let!(:unprocessed_entry) { FactoryBot.build(:entry, bearbeitungsstand: 'unbearbeitet') }
  let!(:deprecated_syntax_entry) { FactoryBot.build(:entry, bearbeitungsstand: 'Code veraltet') }

  before do
    login_as_user(admin)
  end
  describe 'admin visits entries#index' do
    context 'unprocessed entries' do
      it 'are labeled accordingly' do
        unprocessed_entry.save
        visit entries_path
        expect(page.find('span.label-danger').text).to eq('unbearbeitet')
        expect(all('span.label-success').count).to eq(0)
        expect(all('span.label-info').count).to eq(0)
        expect(all('span.label-warning').count).to eq(0)
      end
    end
    context 'formatted entries' do
      it 'are labeled accordingly' do
        formatted_entry.save
        visit entries_path
        expect(page.find('span.label-success').text).to eq('formatiert')
      end
    end
    context 'unformatted entries' do
      it 'are labeled accordingly' do
        unformatted_entry.save
        visit entries_path
        expect(page.find('span.label-info').text).to eq('unformatiert')
      end
    end
    context 'Deprecated syntax entries' do
      it 'are labeled accordingly' do
        deprecated_syntax_entry.save
        visit entries_path
        expect(page.find('span.label-warning').text).to eq('Code veraltet')
      end
    end
  end
end
