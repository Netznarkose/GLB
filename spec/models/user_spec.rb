require 'spec_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:super_admin) { create(:user, email: 'ulrich.apel@uni-tuebingen.de') }

  describe 'general' do
    it 'creates a new instance of a user given valid attributes' do
      expect(user).to be_valid
      expect(user.role).to eq('user')
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:role) }
  end
  context 'deletion' do
    it 'deletes a user that does not holds entries' do
      user
      user.destroy
      expect(user.persisted?).to eq(false)
    end
    it 'does not delete a user that holds entries' do
      user.entries << FactoryBot.create(:entry)
      expect { user.destroy }.to raise_error('User still holds entries')
    end
  end
end
