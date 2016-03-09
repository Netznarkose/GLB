require 'spec_helper'

describe ProfilesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'get edit' do
    context 'as currently logged in editor' do
      it 'I can render my #edit-view' do
        sign_in editor
        get :edit, id: editor.id
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'get update' do
    context 'as currently logged in editor' do
      it 'I can update my name and email and get a confirmation-message' do
        sign_in editor
        put :update, id: editor.id, user: { name: 'different_editor name',
                                            email: 'different_editor@user.com' }
        editor.reload
        expect(editor.name).to eq('different_editor name')
        expect(editor.email).to eq('different_editor@user.com')
        expect(flash[:notice]).to eq('profile updated')
      end
      it 'I get redirected to #edit-view when I make an Input failure
      & get an error-message' do
        sign_in editor
        put :update, id: editor.id, user: { email: '' }
        expect(response).to be_redirect
        # expect(response).to redirect_to(edit_profile_path(editor))
        expect(flash[:notice]).to eq('error')
        put :update, id: editor.id, user: { name: '' }
        expect(flash[:notice]).to eq('error')
      end
      it 'I can not update my role' do
        sign_in editor 
        put :update, id: editor.id, user: { role: 'alien' }
        editor.reload
        expect(editor.role).not_to eq('alien')
        expect(editor.role).to eq('editor')
      end
    end
  end
end
