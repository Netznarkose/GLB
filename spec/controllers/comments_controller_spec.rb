require 'spec_helper'

describe CommentsController, type: :controller do
  let(:comment) { FactoryGirl.create(:comment) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:author) { FactoryGirl.create(:author) }
  let(:commentator) { FactoryGirl.create(:commentator) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET edit' do
    it 'only for pending' do
      pending('authors and commentators only have access to own edit templates')
      subject { get :edit, entry_id: comment.entry_id, id: comment.id }
      it_behaves_like 'something that admin, editor, author and commentator can access'
    end
  end

  describe 'POST create' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'with valid attributes' do
        it 'creates a comment' do
          attributes = FactoryGirl.attributes_for(:comment)
          expect {
            post :create, entry_id: attributes[:entry_id], comment: attributes
          }.to change(Comment, :count).by(1)
          assigns(:comment).tap do |comment|
            expect(comment).to be_valid
            expect(flash[:notice]).to eq('Kommentar erfolgreich erstellt.')
          end
        end
      end
      context 'with invalid attributes' do
        it 'does not creates a comment' do
          attributes = FactoryGirl.attributes_for(:comment, comment: '')
          expect {
            post :create, entry_id: attributes[:entry_id], comment: attributes
          }.to change(Comment, :count).by(0)
          expect(response).to render_template('entries/show')
          expect(flash[:notice]).to eq('Kommentar konnte nicht erstellt werden.')
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
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
    context 'as author' do
      before do
        sign_in author
      end
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
    context 'as commentator' do
      before do
        sign_in commentator
      end
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
    context 'as non-logged-in user' do
      it 'does not creates a comment' do
        attributes = FactoryGirl.attributes_for(:comment)
        expect {
          post :create, entry_id: attributes[:entry_id], comment: attributes
        }.to change(Comment, :count).by(0)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
  end
  describe 'GET update' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: admin.id)
        end
        it 'can be updated' do
          put :update, entry_id: comment.entry_id, id: comment.id,
            comment: { comment: 'hey some changes in the content' }
          comment.reload
          expect(comment.comment).to eq('hey some changes in the content')
          expect(flash[:notice]).to eq('Kommentar erfolgreich bearbeitet.')
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: editor.id)
        end
        it 'can be updated' do
          put :update, entry_id: comment.entry_id, id: comment.id,
            comment: { comment: 'hey some changes in the content' }
          comment.reload
          expect(comment.comment).to eq('hey some changes in the content')
        end
      end
      context 'other users comments' do
        before do
          comment
          comment.update(user_id: author.id)
        end
        it 'can be updated' do
          put :update, entry_id: comment.entry_id, id: comment.id,
            comment: { comment: 'hey some changes in the content' }
          comment.reload
          expect(comment.comment).to eq('hey some changes in the content')
        end
      end
    end
    context 'as author' do
      before do
        sign_in author
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: author.id)
        end
        it 'can be updated' do
          put :update, entry_id: comment.entry_id, id: comment.id,
            comment: { comment: 'hey some changes in the content' }
          comment.reload
          expect(comment.comment).to eq('hey some changes in the content')
        end
      end
    end
    context 'as commentator' do
      before do
        sign_in commentator
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: commentator.id)
        end
        it 'can be updated' do
          put :update, entry_id: comment.entry_id, id: comment.id,
            comment: { comment: 'hey some changes in the content' }
          comment.reload
          expect(comment.comment).to eq('hey some changes in the content')
        end
      end
    end
    context 'as guest' do
      before do
      end
      it 'does not updates a comment' do
        put :update, entry_id: comment.entry_id, id: comment.id,
          comment: { comment: 'hey some changes in the content' }
        comment.reload
        expect(comment.comment).not_to eq('hey some changes in the content')
        expect(comment.comment).to eq(comment.comment)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: admin.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
      context 'other users comments' do
        before do
          comment
          comment.update(user_id: author.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: editor.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
      context 'other users comments' do
        before do
          comment
          comment.update(user_id: author.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
    end
    context 'as author' do
      before do
        sign_in author
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: author.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
      context 'other users comments' do
        before do
          comment
          comment.update(user_id: admin.id)
        end
        it 'can not be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(0)
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
    context 'as commentator' do
      before do
        sign_in commentator
      end
      context 'own comments' do
        before do
          comment
          comment.update(user_id: commentator.id)
        end
        it 'can be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(entry_path(comment.entry))
          expect(flash[:notice]).to eq('Kommentar erfolgreich gelöscht.')
        end
      end
      context 'other users comments' do
        before do
          comment
          comment.update(user_id: admin.id)
        end
        it 'can not be deleted' do
          expect{
            delete :destroy, entry_id: comment.entry_id, id: comment.id
          }.to change(Comment, :count).by(0)
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
    context 'as guest' do
      before do
        comment
      end
      it 'comments can not be deleted' do
        expect{
          delete :destroy, entry_id: comment.entry_id, id: comment.id
        }.to change(Comment, :count).by(0)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
  end
end
