require 'spec_helper'

describe 'displays correct state of editing of entries in index' do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:formatted_entry) { FactoryBot.build(:formatted_entry) }
  let!(:unformatted_entry) { FactoryBot.build(:unformatted_entry) }
  let!(:unprocessed_entry) { FactoryBot.build(:unprocessed_entry) }
  let!(:deprecated_syntax_entry) { FactoryBot.build(:deprecated_syntax_entry) }

  before do
    login_as_user(admin)
  end
  describe 'admin visits entries#index' do
    context 'unprocessed entries' do
      it 'are labeled accordingly' do
        unprocessed_entry.save
        visit entries_path
        expect(page.find('span.label-danger').text).to eq('unbearbeitet')
        ['info', 'success', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'formatted entries' do
      it 'are labeled accordingly' do
        formatted_entry.save
        visit entries_path
        expect(page.find('span.label-success').text).to eq('formatiert')
        ['info', 'danger', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'unformatted entries' do
      it 'are labeled accordingly' do
        unformatted_entry.save
        visit entries_path
        expect(page.find('span.label-info').text).to eq('unformatiert')
        ['success', 'danger', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'Deprecated syntax entries' do
      it 'are labeled accordingly' do
        deprecated_syntax_entry.save
        visit entries_path
        expect(page.find('span.label-warning').text).to eq('Code veraltet')
        ['success', 'danger', 'info'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
  end
end
