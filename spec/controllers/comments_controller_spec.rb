require 'spec_helper'

describe CommentsController, type: :controller do
  let(:comment) { FactoryGirl.create(:comment) }
  let(:admin) { FactoryGirl.create(:admin) }

  before :each do
    admin
    sign_in admin
  end

  describe 'GET edit' do
    it 'edits a comment' do
      get :edit, entry_id: comment.entry_id, id: comment.id
      expect(response).to render_template('edit')
    end
  end
  describe 'POST create' do
    context 'with valid attributes' do
      it 'creates a comment' do
        attributes = FactoryGirl.attributes_for(:comment)
        expect {
          post :create, entry_id: attributes[:entry_id], comment: attributes
        }.to change(Comment, :count).by(1)
        assigns(:comment).tap do |comment|
          expect(comment).to be_valid
        end
      end
    end
    context 'with invalid attributes' do
      it 'does not creates a comment' do
        attributes = FactoryGirl.attributes_for(:comment, comment: '')
        expect {
          post :create, entry_id: attributes[:entry_id], comment: attributes
        }.to change(Comment, :count).by(0)
        assigns(:comment).tap do |comment|
          expect(comment).not_to be_valid
        end
        expect(response).to render_template('entries/show')
      end
    end
  end
  describe 'GET update' do
    it 'updates a comment' do
      put :update, entry_id: comment.entry_id, id: comment.id,
        comment: { comment: 'hey some changes in the content' }
      comment.reload
      expect(comment.comment).to eq('hey some changes in the content')
    end
  end

  describe 'DELETE destroy' do
    before do
      comment
    end
    it 'deletes a comment' do
      expect{
        delete :destroy, entry_id: comment.entry_id, id: comment.id
      }.to change(Comment, :count).by(-1)
      expect(response).to redirect_to(entry_path(comment.entry))
      expect(flash[:notice]).not_to be_empty
    end
  end
end
