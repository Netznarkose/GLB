require 'spec_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  describe 'general' do
    it 'creates a new instance of a comment given valid attributes' do
      expect(comment).to be_persisted
      expect(comment).to be_valid
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:entry_id) }
    it { should validate_presence_of(:comment) }
  end
end
