require 'spec_helper'

describe UsersController, type: :controller do
  let(:ulrich_appel) { FactoryGirl.create(:admin, email: 'ulrich.apel@uni-tuebingen.de') }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:author) { FactoryGirl.create(:author) }
  let(:commentator) { FactoryGirl.create(:commentator) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'get index' do
    subject { get :index }

    it_behaves_like 'something that admin, editor & author can access'
    it_behaves_like 'something that commentator and guest can not access'
  end

  describe 'get new' do
    context 'as admin' do
      before do
        sign_in admin
        get :new
      end
      it 'renders the view' do
        expect(response).to render_template :new
      end
      it 'assigns a new user-instance' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
    context 'as non-admin' do
      subject { get :new }

      it_behaves_like 'something that only admin can access'
    end
  end

  describe 'POST create' do
    context 'as admin' do
      context 'with valid attributes' do
        before do
          sign_in admin
          post :create, user: FactoryGirl.attributes_for(:user)
        end
        it 'creates a new user' do
          expect {
            post :create, user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)
        end
        it 'redirect to the new user' do
          expect(response).to redirect_to(users_path)
        end
        it 'shows a confirmation message' do
          expect(flash[:notice]).to eq('Mitarbeiter erfolgreich erstellt!')
        end
      end
      context 'with invalid attributes' do
        before do
          sign_in admin
          post :create, user: FactoryGirl.attributes_for(:user, name: '')
        end
        it 'does not create a new user' do
          expect {
            post :create, user: FactoryGirl.attributes_for(:author, name: '')
          }.to_not change(User, :count)
        end
        it 'redirects to the new-template' do
          expect(response).to redirect_to(new_user_path)
        end
        it 'shows an error-message' do
          expect(flash[:notice]).not_to be_empty
        end
      end
    end
    context 'as non-admin' do
      subject { post :create, user: FactoryGirl.attributes_for(:user) }

      it_behaves_like 'something that only admin can access'
    end
  end

  describe 'get edit' do
    context 'as admin' do
      it 'renders the view' do
        sign_in admin
        get :edit, id: author.id
        expect(response).to render_template(:edit)
      end
    end
    context 'as non-admin' do
      subject { post :edit, id: author.id }

      it_behaves_like 'something that only admin can access'
    end
  end

  describe 'get update' do
    context 'as admin' do
      before do
        sign_in admin
      end
      it 'I can update someone elses role' do
        put :update, id: author.id, user: { role: 'admin' }
        author.reload
        expect(author.role).to eq('admin')
      end
    end
    context 'as non-admin' do
      subject { put :update, id: author.id, user: { role: 'admin' } }

      it_behaves_like 'something that only admin can access'
    end
  end


  describe 'DELETE destroy' do
    before do
      user
      ulrich_appel
    end
    context 'as admin' do
      before do
        sign_in admin
      end
      it 'I can delete users and get redirected to users index' do
        expect{
          delete :destroy, id: user.id
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(users_path)
      end
    end
    context 'as non-admin' do
      subject { delete :destroy, id: user.id }

      it_behaves_like 'something that only admin can access'
    end
  end
end
