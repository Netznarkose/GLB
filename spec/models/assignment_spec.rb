require 'spec_helper'

RSpec.describe Assignment, type: :model do
  let!(:assignment) { FactoryBot.create(:assignment) }
  let!(:entry) { FactoryBot.create(:entry) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(assignment).to be_valid
    end
    it 'is invalid without assigned_from_user' do
      assignment.assigned_from_user = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without assigned_to_user' do
      assignment.assigned_to_user = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without assigned_at_date' do
      assignment.assigned_at_date = nil
      expect(assignment).not_to be_valid
    end
    it 'is invalid without assigned_to_date' do
      assignment.assigned_to_date = nil
      expect(assignment).not_to be_valid
    end
  end

  describe 'date' do
    it 'sets date of createion as assigned_at_date' do
      expect(assignment.assigned_at_date).to eq(Date.today)
    end
    it 'sets date of expiry to 3 month after creation' do
      expect(assignment.assigned_to_date).to eq(Date.today + 3.month)
    end
  end
  describe 'expired?' do
    it 'returns true if assignment is expired' do
      assignment.update(assigned_to_date: Date.yesterday)
      expect(assignment.expired?).to eq(true)
    end
    it 'returns false if assignment is expired' do
      assignment.save
      expect(assignment.expired?).to eq(false)
    end
  end
end
