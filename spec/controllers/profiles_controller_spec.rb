require 'spec_helper'

describe ProfilesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

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
      context 'with valid attributes' do
        before do
          sign_in editor
          put :update, id: editor.id, user: { name: 'different_editor name',
                                              email: 'different_editor@user.com' }
        end
        it 'I can update name & email' do
          editor.reload
          expect(editor.name).to eq('different_editor name')
          expect(editor.email).to eq('different_editor@user.com')
        end
        it 'I get a confirmation-message' do
          expect(flash[:notice]).to eq('profile updated')
        end
      end
      context 'with invalid attributes' do
        before do
          sign_in editor
          put :update, id: editor.id, user: { email: '' }
        end
        it 'I get redirected to edit-template' do
          expect(response).to be_redirect
        end
        it 'I get an error-message' do
          expect(flash[:notice]).to eq('error')
        end
      end
    end
    context 'as non-logged-in user' do
      it 'I can not update my profile' do
        put :update, id: editor.id, user: { name: 'different_editor name' }
        editor.reload
        expect(editor.name).not_to eq('different_editor name')
        expect(editor.name).to eq(editor.name)
      end
    end
  end
end
