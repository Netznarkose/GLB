require 'spec_helper'

describe UsersController, type: :controller do
  let(:superadmin) { FactoryGirl.create(:superadmin) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'get index' do
    subject { get :index } 

    it_behaves_like 'something that admin, chiefeditor & editor can access'
    it_behaves_like 'something that commentator and guest can not access'
  end

  describe 'get new' do
    context 'as admin' do
      it 'assigns a new user to @User & renders #new-view' do
        sign_in admin
        get :new
        expect(assigns(:user)).to be_a_new(User)
        expect(response).to render_template :new
      end
    end
    subject { get :new } 

    it_behaves_like 'something that only admin can access'
  end

  describe 'POST create' do
    context 'as admin' do
      context 'with valid attributes' do
        it 'creates a new user, redirects to index-template
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
        it 'does not create a new user, redirects to the new-template
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
    subject { post :create, user: FactoryGirl.attributes_for(:user) } 

    it_behaves_like 'something that only admin can access'
  end

  describe 'get edit' do
    context 'as admin' do
      it 'I can visit the edit template' do
        sign_in admin 
        get :edit, id: editor.id
        expect(response).to render_template(:edit)
      end
    end
    subject { post :edit, id: editor.id } 

    it_behaves_like 'something that only admin can access'
  end

  describe 'get update' do
    context 'as admin' do
      it 'I can update someone elses role' do
        sign_in admin 
        put :update, id: editor.id, user: { role: 'admin' }
        editor.reload
        expect(editor.role).to eq('admin')
      end
    end
    subject { put :update, id: editor.id, user: { role: 'admin' } } 

    it_behaves_like 'something that only admin can access'
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
    subject { delete :destroy, id: user.id } 

    it_behaves_like 'something that only admin can access'
  end
end
