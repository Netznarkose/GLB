require 'spec_helper'

describe 'sort user entries' do
  let(:admin) { create(:admin) }
  let!(:formatted_entry) { build(:formatted_entry) }
  let!(:admins_formatted_entry) { build(:formatted_entry, user_id: admin.id, japanische_umschrift: 'admins_formatted_entry') }
  let!(:unformatted_entry) { build(:unformatted_entry) }
  let!(:admins_unformatted_entry) { build(:unformatted_entry, user_id: admin.id, japanische_umschrift: 'admins_unformatted_entry') }
  let!(:unprocessed_entry) { build(:unprocessed_entry) }
  let!(:admins_unprocessed_entry) { build(:unprocessed_entry, user_id: admin.id, japanische_umschrift: 'admins_unprocessed_entry') }
  let!(:deprecated_syntax_entry) { build(:deprecated_syntax_entry) }
  let!(:admins_deprecated_syntax_entry) { build(:deprecated_syntax_entry, user_id: admin.id, japanische_umschrift: 'admins_deprecated_syntax_entry') }

  def create_set_of_entries_of_all_formats
    formatted_entry.save
    unformatted_entry.save
    unprocessed_entry.save
    deprecated_syntax_entry.save
  end


  before do
    login_as_user(admin)
  end
  describe 'admin filters' do
    context 'formatted entries' do
      before do
        create_set_of_entries_of_all_formats
        admins_formatted_entry.save
        visit user_entries_path(admin.id)
        click_link 'Formatiert'
      end
      it 'shows admins formatted entries' do
        expect(all('td')[0].text).to eq('admins_formatted_entry')
        expect(all("span.label-success").count).to eq(1)
        expect(page.find('span.label-success').text).to eq('formatiert')
      end
      it 'does not show entries in other states of editing' do
        ['danger', 'info', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'unformatted entries' do
      before do
        create_set_of_entries_of_all_formats
        admins_unformatted_entry.save
        visit user_entries_path(admin.id)
        click_link 'Unformatiert'
      end
      it 'shows admins unformatted entries' do
        expect(all('td')[0].text).to eq('admins_unformatted_entry')
        expect(all("span.label-info").count).to eq(1)
        expect(page.find('span.label-info').text).to eq('unformatiert')
      end
      it 'does not show entries in other states of editing' do
        ['danger', 'success', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'unprocessed entries' do
      before do
        create_set_of_entries_of_all_formats
        admins_unprocessed_entry.save
        visit user_entries_path(admin.id)
        click_link 'Unbearbeitet'
      end
      it 'shows admins unprocessed entries' do
        expect(all('td')[0].text).to eq('admins_unprocessed_entry')
        expect(all("span.label-danger").count).to eq(1)
        expect(page.find('span.label-danger').text).to eq('unbearbeitet')
      end
      it 'does not show entries in other states of editing' do
        ['info', 'success', 'warning'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
    context 'deprecated syntax entries' do
      before do
        create_set_of_entries_of_all_formats
        admins_deprecated_syntax_entry.save
        visit user_entries_path(admin.id)
        click_link 'Code Veraltet'
      end
      it 'shows admins deprecated_syntax entries' do
        expect(all('td')[0].text).to eq('admins_deprecated_syntax_entry')
        expect(all("span.label-warning").count).to eq(1)
        expect(page.find('span.label-warning').text).to eq('Code veraltet')
      end
      it 'does not show entries in other states of editing' do
        ['info', 'success', 'danger'].each do |label|
          expect(all("span.label-#{label}").count).to eq(0)
        end
      end
    end
  end
  describe 'sort' do
    before do
      create(:unprocessed_entry, id: 3, user_id: admin.id, japanische_umschrift: 'Aalhaus')
      create(:unprocessed_entry, id: 1, user_id: admin.id, japanische_umschrift: 'Rote Flora')
      create(:unprocessed_entry, id: 2, user_id: admin.id, japanische_umschrift: 'Zeise')
    end
    describe 'it sorts admins entries' do
      it 'in ascending order' do
        visit user_entries_path(admin.id)
        click_button 'Felder Auswahl'
        click_link 'Unbearbeitet'
        expect(all('td')[0].text).to eq('Aalhaus')
        expect(all('td')[16].text).to eq('Zeise')
      end
      it 'in descending order' do
        visit user_entries_path(admin.id)
        click_link 'Unbearbeitet (rev)'
        expect(all('td')[0].text).to eq('Zeise')
        expect(all('td')[16].text).to eq('Aalhaus')
      end
    end
  end
end
