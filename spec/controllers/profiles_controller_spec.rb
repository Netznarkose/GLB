require 'spec_helper'

describe ProfilesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }
  let(:guest) { FactoryGirl.create(:guest) }

  describe 'get edit' do
    context 'as logged-in user' do
      it 'I can render the edit-template' do
        sign_in editor
        get :edit, id: editor.id
        expect(response).to render_template(:edit)
      end
    end
    context 'as non-logged-in user' do
      it 'I can not render the edit-template' do
        get :edit, id: editor.id
        expect(response).not_to render_template(:edit)
      end
    end
  end

  describe 'get update' do
    context 'as logged-in user' do
      before do
        sign_in admin
      end
      context 'with valid attributes' do
        before do
          put :update, id: admin.id, user: { name: 'different_editor name',
                                             email: 'different_editor@user.com' }
          admin.reload
        end
        it 'I can update my name & email' do
          expect(admin.name).to eq('different_editor name')
          expect(admin.email).to eq('different_editor@user.com')
        end
        it 'I get a confirmation-message' do
          expect(flash[:notice]).to eq('profile updated')
        end
      end
      context 'with invalid attributes' do
        before do
          put :update, id: editor.id, user: { email: '' }
          editor.reload
        end
        it 'I get redirected to edit-template' do
          expect(response).to be_redirect
        end
        it 'I get an error-message' do
          expect(flash[:notice]).to eq('error')
        end
      end
      it 'I can not update update somebody else\'s profile' do
        editor
        put :update, id: editor.id, user: { name: 'different_editor name' }
        editor.reload
        expect(editor.name).not_to eq('different_editor name')
        expect(editor.name).to eq(editor.name)
      end
    end
    context 'as not logged-in user' do
      it 'I can not update somebody else\'s profile' do
        put :update, id: editor.id, user: { name: 'different_editor name' }
        editor.reload
        expect(editor.name).not_to eq('different_editor name')
        expect(editor.name).to eq(editor.name)
      end
    end
    context 'as guest' do
      before do
        sign_in guest
      end
      it 'I can not update somebody else\'s profile' do
        put :update, id: editor.id, user: { name: 'different_editor name' }
        editor.reload
        expect(editor.name).not_to eq('different_editor name')
        expect(editor.name).to eq(editor.name)
      end
    end
  end
end
