require 'spec_helper'

describe User do
  let(:editor) { FactoryGirl.create(:editor) }

  before do
    editor
  end
  it "should create a new instance of a user
  given valid attributes" do
    expect(editor).to be_valid
    expect(editor.role).to eq('editor')
  end

  it "is invalid without name" do
    editor.name = nil
    expect(editor).not_to be_valid
  end

  it "is invalid without email" do
    editor.email= nil
    expect(editor).not_to be_valid
  end

  it "is invalid without password" do
    editor.password = nil
    expect(editor).not_to be_valid
  end

  context 'if we delete a user' do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:superadmin) { FactoryGirl.create(:superadmin) }

    it "does not delete the corresponding entries" do
      superadmin
      admin.entries << FactoryGirl.create(:entry)
      admin.destroy # model level
      expect(Entry.count).to eq(1)
    end
    # it "does not delete the corresponding entries2" do
    #   entry = FactoryGirl.create(:entry, user_id: admin.id)
    #   admin.destroy # model level
    #   expect(entry.persisted?).to be(true)
    # end
    # it "nullify all corresponding entries" do
    #   admin.entries << FactoryGirl.create(:entry)
    #   entry = admin.entries.first
    #   admin.destroy 
    #   entry.reload
    #   expect(entry.user_id).to be(nil)
    #   expect(entry.user_id).to eq(1)
    # end
    it "should assign all corresponding entries to superadmin" do
      superadmin
      admin.entries << FactoryGirl.create(:entry)
      entry = admin.entries.first
      admin.destroy 
      entry.reload
      expect(entry.user).to eq(superadmin)
    end


      
  end
end

