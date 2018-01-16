require 'spec_helper'

describe CommentsController, type: :controller do
  let(:comment) { FactoryBot.create(:comment) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:editor) { FactoryBot.create(:editor) }
  let(:author) { FactoryBot.create(:author) }
  let(:commentator) { FactoryBot.create(:commentator) }
  let(:user) { FactoryBot.create(:user) }

  describe 'GET edit' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'own comments' do
        it 'are getting edited' do
          comment.update(user_id: admin.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
      context 'other users comments' do
        it 'are getting edited' do
          comment.update(user_id: editor.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
      context 'own comments' do
        it 'are getting edited' do
          comment.update(user_id: editor.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
      context 'other users comments' do
        it 'are getting edited' do
          comment.update(user_id: author.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
    end
    context 'as commentator' do
      before do
        sign_in commentator
      end
      context 'own comments' do
        it 'are getting edited' do
          comment.update(user_id: commentator.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
      context 'other users comments' do
        it 'are not getting edited' do
          comment.update(user_id: admin.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).not_to render_template('entries/show')
          expect(flash[:notice]).to eq('Zugriff verwehrt')
        end
      end
    end
    context 'as author' do
      before do
        sign_in author
      end
      context 'own comments' do
        it 'are getting edited' do
          comment.update(user_id: author.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).to render_template('entries/show')
        end
      end
      context 'other users comments' do
        it 'are not getting edited' do
          comment.update(user_id: admin.id)
          get :edit, entry_id: comment.entry_id, id: comment.id
          expect(response).not_to render_template('entries/show')
          expect(flash[:notice]).to eq('Zugriff verwehrt')
        end
      end
    end
    context 'guest' do
      it 'comments do not get edited' do
        comment.update(user_id: author.id)
        get :edit, entry_id: comment.entry_id, id: comment.id
        expect(response).not_to render_template('entries/show')
        expect(flash[:notice]).to eq('Zugriff verwehrt')
      end
    end
  end

  describe 'POST create' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'with valid attributes' do
        it 'creates a comment' do
          attributes = FactoryBot.attributes_for(:comment)
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
          attributes = FactoryBot.attributes_for(:comment, comment: '')
          expect {
            post :create, entry_id: attributes[:entry_id], comment: attributes
          }.to change(Comment, :count).by(0)
          expect(response).to render_template('entries/show')
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
      context 'with valid attributes' do
        it 'creates a comment' do
          attributes = FactoryBot.attributes_for(:comment)
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
          attributes = FactoryBot.attributes_for(:comment, comment: '')
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
          attributes = FactoryBot.attributes_for(:comment)
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
          attributes = FactoryBot.attributes_for(:comment, comment: '')
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
          attributes = FactoryBot.attributes_for(:comment)
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
          attributes = FactoryBot.attributes_for(:comment, comment: '')
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
        attributes = FactoryBot.attributes_for(:comment)
        expect {
          post :create, entry_id: attributes[:entry_id], comment: attributes
        }.to change(Comment, :count).by(0)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Zugriff verwehrt')
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
          expect(flash[:notice]).to eq('Zugriff verwehrt')
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
          expect(flash[:notice]).to eq('Zugriff verwehrt')
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
        expect(flash[:notice]).to eq('Zugriff verwehrt')
      end
    end
  end
end
