require 'spec_helper'

describe User do
  let!(:user) { FactoryGirl.create(:user) }

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

  context 'if we delete a user' do
    let(:ulrich_appel) do
      FactoryGirl.create(:admin, email: 'ulrich.apel@uni-tuebingen.de')
    end

    it 'does not delete a user that holds entries' do
      user.entries << FactoryGirl.create(:entry)
      expect { user.destroy }.to raise_error("User still holds entries")
    end
    # it 'does not delete the corresponding entries' do
    #   ulrich_appel
    #   user.entries << FactoryGirl.create(:entry)
    #   user.destroy # model level
    #   expect(Entry.count).to eq(1)
    # end
    # it 'should assign all corresponding entries to ulrich appel' do
    #   ulrich_appel
    #   user.entries << FactoryGirl.create(:entry)
    #   entry = user.entries.first
    #   user.destroy
    #   entry.reload
    #   expect(entry.user).to eq(ulrich_appel)
    # end
  end
end
