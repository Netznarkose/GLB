require 'spec_helper'

describe UsersController, type: :controller do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'get index' do
    context 'as admin' do
      it 'shows user index' do
        sign_in admin
        get :index
        expect(response).to be_success
      end
    end
    context 'as editor' do
      it 'does not show user index' do
        sign_in editor
        get :index
        expect(response).to be_redirect
      end
    end
  end

  describe 'get new' do
    context 'as admin' do
      it 'assigns a new user to @User & renders #new-view' do
        sign_in admin
        get :new
        expect(assigns(:user)).to be_a_new(User)
        expect(response).to be_success
        expect(response).to render_template :new
      end
    end
    context 'as editor' do
      it 'redirects to homepage & shows an error-message' do
        sign_in editor
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
  end

  describe 'POST create' do
    context 'as admin' do
      context 'with valid attributes' do
        it 'creates a new contact, redirects to user-index
        & shows a confirmation-message' do
          sign_in admin
          expect {
            post :create, user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
          expect(response).to redirect_to(users_path)
          expect(flash[:notice]).to eq('Mitarbeiter erfolgreich erstellt!')
        end
      end
      context 'with invalid attributes' do
        it 'does not create a new contact, redirects to #new-view
        & shows an error-message' do
          sign_in admin
          expect {
            post :create, user: FactoryGirl.attributes_for(:editor, name: '')
          }.to_not change(User, :count)
          expect(response).to redirect_to(new_user_path)
          expect(flash[:notice]).not_to be_empty
        end
      end
    end
    context 'as editor' do
      it 'does not create a new contact, redirects to homepage
      and shows an error-message' do
        sign_in editor
        expect {
          post :create, user: FactoryGirl.attributes_for(:user)
        }.to_not change(User, :count)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'get edit' do
    context 'as currently logged in editor' do
      it 'I can not render my #edit-view and get 
      redirected to profile controller edit' do
        sign_in editor
        get :edit, id: editor.id
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(edit_profile_path(editor))
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
    context 'as currently logged in editor' do
      it 'I can not update my role' do
        sign_in editor 
        put :update, id: editor.id, user: { role: 'admin' }
        editor.reload
        expect(editor.role).not_to eq('admin')
        expect(editor.role).to eq('editor')
      end
      it 'I can not update someone elses profile' do
        sign_in editor 
        put :update, id: user.id, user: { name: 'different_user name' }
        user.reload
        expect(user.name).not_to eq('different_user name')
      end
    end
    context 'as currently logged in admin' do
      it 'I can update someone elses role' do
        sign_in admin 
        put :update, id: editor.id, user: { role: 'admin' }
        editor.reload
        expect(editor.role).to eq('admin')
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      user
      superadmin
    end
    context 'as admin' do
      it 'I can delete users and get redirected to users index' do
        sign_in admin
        expect{
          delete :destroy, id: user.id
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(users_path)
      end
    end
    context 'as editor' do
      it 'I can not delete users, get redirected to homepage
      and get an error-message' do
        sign_in editor
        expect{
          delete :destroy, id: user.id
        }.to change(User, :count).by(0)
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
  end
end
