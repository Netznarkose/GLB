require 'spec_helper'


describe CommentsController, :type => :controller do

  let(:comment) { FactoryGirl.create(:comment) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    admin
  end
  describe "POST create" do
    context "Admin is able to create a comment" do
      before :each do
        sign_in admin
      end

      it "creates a valid comment when entering 
      valid data" do
        attributes = FactoryGirl.attributes_for(:comment) 
        expect {
          post :create, comment: attributes
        }.to change(Comment, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(comment).to be_valid
        end
      end
      it "does not creates a comment when entering 
      invalid data" do
        attributes = FactoryGirl.attributes_for(:comment, comment: "") 
        expect {
          post :create, comment: attributes
        }.to change(Comment, :count).by(0)
        expect(response).to render_template('entries/show')
      end
    end
  end
end


