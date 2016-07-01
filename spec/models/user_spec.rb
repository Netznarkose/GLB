require 'spec_helper'

describe User do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:super_admin) { FactoryGirl.create(:user, email: 'ulrich.apel@uni-tuebingen.de') }

  it 'should create a new instance of a user
  given valid attributes' do
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
    it 'does not delete a user that holds entries' do
      user.entries << FactoryGirl.create(:entry)
      expect { user.destroy }.to raise_error('User still holds entries')
    end

    it 'assigns remaining entries to super admin' do
      user.entries << FactoryGirl.create(:entry)
      entry = user.entries.first
      user.assign_remaining_entries_to_super_admin
      entry.reload
      expect(entry.user).to eq(super_admin)
    end
    it 'deletes user entries when transfer of entries was successfull' do
      pending('todo')
      raise
    end
  end
end
