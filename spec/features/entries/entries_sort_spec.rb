require 'spec_helper'

xdescribe 'search index' do
  let(:admin) { create(:admin) }
  let!(:formatted_entry) { build(:entry, bearbeitungsstand: 'formatiert') }
  let!(:unformatted_entry) { build(:entry, bearbeitungsstand: 'unformatiert') }
  let!(:unprocessed_entry) { build(:entry, bearbeitungsstand: 'unbearbeitet') }
  let!(:deprecated_syntax_entry) { build(:entry, bearbeitungsstand: 'Code veraltet') }

  before do
    login_as_user(admin)
  end
  describe 'admin searches' do
    it 'x' do
    end
  end
end
