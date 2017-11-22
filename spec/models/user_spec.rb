require 'spec_helper'

describe User do
  let!(:user) { FactoryBot.create(:user) }
  let!(:super_admin) { FactoryBot.create(:user, email: 'ulrich.apel@uni-tuebingen.de') }

  it 'creates a new instance of a user given valid attributes' do
    expect(user).to be_valid
    expect(user.role).to eq('user')
  end

  it 'is invalid without name' do
    user.name = nil
    expect(user).not_to be_valid
  end

  it 'is invalid without email' do
    user.email = nil
    expect(user).not_to be_valid
  end

  it 'is invalid without password' do
    user.password = nil
    expect(user).not_to be_valid
  end

  it 'is invalid without role' do
    user.role = nil
    expect(user).not_to be_valid
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
