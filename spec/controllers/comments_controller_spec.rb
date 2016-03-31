require 'spec_helper'

describe CommentsController, type: :controller do
  let(:comment) { FactoryGirl.create(:comment) }
  let(:admin) { FactoryGirl.create(:admin) }

  before :each do
    admin
  end

  describe 'get edit' do
    context 'Admin is able to edit a comment' do
      it 'Edits a comment' do
        sign_in admin 
        get :edit, id: comment.id
        expect(response).to redirect_to(entry_path(comment.entry))
      end
    end
  end
  describe 'get update' do
    context 'Admin is able to update a Comment' do
      it 'Admin is able to update a Comment' do
        sign_in admin 
        put :update, id: comment.id, comment: { comment: 'hey some changes in the content' }
        comment.reload
        expect(comment.comment).to eq('hey some changes in the content')
      end
    end
  end


  describe 'POST create' do
    context 'Admin is able to create a comment' do
      before :each do
        sign_in admin
      end

      it 'creates a valid comment when entering
      valid data' do
        attributes = FactoryGirl.attributes_for(:comment)
        expect {
          post :create, comment: attributes
        }.to change(Comment, :count).by(1)
        assigns(:comment).tap do |comment|
          expect(comment).to be_valid
        end
      end
      it 'does not creates a comment when entering
      invalid data' do
        attributes = FactoryGirl.attributes_for(:comment, comment: '')
        expect {
          post :create, comment: attributes
        }.to change(Comment, :count).by(0)
        expect(response).to render_template('entries/show')
      end
    end
  end
  describe 'DELETE destroy' do
    before do
      admin
      comment
    end
    context 'Admin is able to delete a comment' do
      it 'I deletes a comment' do
        sign_in admin
        expect{
          delete :destroy, id: comment.id
        }.to change(Comment, :count).by(-1)
        expect(response).to redirect_to(entry_path(comment.entry))
        expect(flash[:notice]).not_to be_empty
      end
    end
  end
end
