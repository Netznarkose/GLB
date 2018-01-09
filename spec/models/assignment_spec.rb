require 'spec_helper'

RSpec.describe Assignment, type: :model do
  let!(:assignment) { create(:assignment) }
  let!(:entry) { create(:entry) }

  describe 'general' do
    it 'has a valid factory' do
      expect(assignment).to be_valid
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:creator_id) }
    it { should validate_presence_of(:recipient_id) }
    it { should validate_presence_of(:from_date) }
    it { should validate_presence_of(:to_date) }
    it { should validate_presence_of(:entry_id) }
    it { should validate_uniqueness_of(:entry_id) }
  end

  describe 'date' do
    it 'sets date of creation as from_date' do
      expect(assignment.from_date).to eq(Date.today)
    end
    it 'sets date of expiry to 3 month after creation' do
      expect(assignment.to_date).to eq(Date.today + 3.month)
    end
  end
  describe 'expired?' do
    it 'returns true if assignment is expired' do
      assignment.update(to_date: Date.yesterday)
      expect(assignment.expired?).to eq(true)
    end
    it 'returns false if assignment is not expired' do
      assignment.save
      expect(assignment.expired?).to eq(false)
    end
  end

  describe 'remindable?' do
    it 'returns true if two/third of processing-time elapsed' do
      Timecop.freeze(Date.today + 2. month + 2.days) do
        expect(assignment.remindable?).to eq(true)
      end
    end
    it 'returns false if assignment is not remindable' do
      expect(assignment.remindable?).to eq(false)
    end
  end
end
