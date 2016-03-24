require 'spec_helper'

describe Comment do
  let(:comment) { FactoryGirl.create(:comment) }
  before do
    comment
  end
  it "creates a new instance of an entry given valid attributes" do
    expect(comment).to be_persisted
    expect(comment).to be_valid
  end

  it "is invalid without user_id" do
    comment.user_id = nil
    expect(comment).not_to be_valid
  end

  it "is invalid without entry_id" do
    comment.entry_id = nil
    expect(comment).not_to be_valid
  end

  it "is invalid without comment" do
    comment.comment = nil
    expect(comment).not_to be_valid
  end
end
