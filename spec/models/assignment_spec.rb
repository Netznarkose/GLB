require 'spec_helper'

RSpec.describe Assignment, type: :model do
  let!(:assignment) { FactoryBot.create(:assignment) }
  let!(:entry) { FactoryBot.create(:entry) }

  describe 'general' do
    it 'has a valid factory' do
      expect(assignment).to be_valid
    end
  end

  describe 'validations' do
    it 'is invalid without creator_id' do
      assignment.creator_id = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without recipient_id' do
      assignment.recipient_id = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without from_date' do
      assignment.from_date = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without to_date' do
      assignment.to_date = nil
      expect(assignment).not_to be_valid
    end
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
    it 'returns false if assignment is expired' do
      assignment.save
      expect(assignment.expired?).to eq(false)
    end
  end
end
