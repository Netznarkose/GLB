require 'spec_helper'

RSpec.describe Task, type: :model do
  let!(:task) { FactoryBot.create(:task) }
  let!(:entry) { FactoryBot.create(:entry) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(task).to be_valid
    end
    it 'is invalid without assigned_from_user' do
      task.assigned_from_user = nil
      expect(task).not_to be_valid
    end
    it 'is invalid without assigned_to_user' do
      task.assigned_to_user = nil
      expect(task).not_to be_valid
    end
    it 'is invalid without assigned_at_date' do
      task.assigned_at_date = nil
      expect(task).not_to be_valid
    end
    it 'is invalid without assigned_to_date' do
      task.assigned_to_date = nil
      expect(task).not_to be_valid
    end
  end

  describe 'date' do
    it 'sets date of createion as assigned_at_date' do
      expect(task.assigned_at_date).to eq(Date.today)
    end
    it 'sets date of expiry to 3 month after creation' do
      expect(task.assigned_to_date).to eq(Date.today + 3.month)
    end
  end

  describe 'entry' do
    it 'returns assigned entry' do
      task.assigned_entry = entry.id
      expect(task.entry.id).to eq(entry.id)
    end
  end
end
