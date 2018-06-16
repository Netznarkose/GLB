require 'spec_helper'

RSpec.describe Entry, type: :model do
  let(:entry)                  { create(:entry) }

  describe 'general' do
    it 'creates a new instance of an entry given valid attributes' do
      expect(entry).to be_persisted
      expect(entry).to be_valid
    end
  end
end
