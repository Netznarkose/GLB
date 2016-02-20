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
      it 'I get redirected to homepage when I try to render
      someone elses #edit-view & get an error-message' do
        sign_in editor 
        get :edit, id: user.id
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
  end

  describe 'get update' do
    context 'as admin' do
      it 'i can make editors to admins' do
        user
        # binding.pry
        sign_in admin
        put :update, id: editor.id, user: { role: 'admin' }
        expect(assigns(:user)).to eq(editor)
        editor.reload
        expect(editor.role).to eq('admin')
      end
    end
    context 'as editor' do
      it 'i can not change any roles' do
        sign_in editor
        put :update, id: editor.id, user: { role: 'admin' }
        editor.reload
        expect(editor.role).not_to eq('admin')
        expect(editor.role).to eq('editor')
      end
    end
    context 'as currently loggin editor' do
      it 'I can update my name and email and get a confirmation-message' do
        sign_in editor
        put :update, id: editor.id, user: { name: 'different_editor name',
                                            email: 'different_editor@user.com' }
        editor.reload
        expect(editor.name).to eq('different_editor name')
        expect(editor.email).to eq('different_editor@user.com')
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
      it 'I get redirected to #edit-view when I make an Input failure
      & get an error-message' do
        sign_in editor
        put :update, id: editor.id, user: { email: '' }
        expect(response).to redirect_to edit_user_path(editor)
        expect(flash[:notice]).to eq('Email darf nicht leer sein!')
        put :update, id: editor.id, user: { name: '' }
        expect(flash[:notice]).to eq('Name darf nicht leer sein!')
      end
      it 'I can not update my role' do
        # pending('role is currently managed in the update_role action')
        sign_in editor 
        put :update, id: editor.id, user: { role: 'alien' }
        editor.reload
        expect(editor.role).not_to eq('alien')
        expect(editor.role).to eq('editor')
      end
      it 'I can not update someone elses profile' do
        sign_in editor 
        put :update, id: user.id, user: { name: 'different_user name' }
        user.reload
        expect(user.name).not_to eq('different_user name')
      end
    end
  end
end
