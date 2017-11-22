require 'spec_helper'

describe UsersController, type: :controller do
  let(:super_admin) { FactoryBot.create(:admin, email: 'ulrich.apel@uni-tuebingen.de') }
  let(:admin) { FactoryBot.create(:admin) }
  let(:editor) { FactoryBot.create(:editor) }
  let(:author) { FactoryBot.create(:author) }
  let(:commentator) { FactoryBot.create(:commentator) }
  let(:user) { FactoryBot.create(:user) }

  describe 'GET index' do
    subject { get :index }

    it_behaves_like 'something that admin, editor & author can access'
    it_behaves_like 'something that commentator and guest can not access'
  end

  describe 'GET new' do
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
          post :create, user: FactoryBot.attributes_for(:user)
        end
        it 'creates a new user' do
          expect {
            post :create, user: FactoryBot.attributes_for(:user)
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
          post :create, user: FactoryBot.attributes_for(:user, name: '')
        end
        it 'does not create a new user' do
          expect {
            post :create, user: FactoryBot.attributes_for(:author, name: '')
          }.to_not change(User, :count)
        end
        it 'redirects to the new-template' do
          expect(response).to render_template(:new)
        end
      end
    end
    context 'as non-admin' do
      subject { post :create, user: FactoryBot.attributes_for(:user) }

      it_behaves_like 'something that only admin can access'
    end
  end

  describe 'GET edit' do
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

  describe 'PUT update' do
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
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'users without entries' do
        before do
          user
        end
        it 'get deleted' do
          expect{
            delete :destroy, id: user.id
          }.to change(User, :count).by(-1)
        end
        it 'admin gets redirected to user-index and a notification' do
          delete :destroy, id: user.id
          expect(response).to redirect_to(users_path)
          expect(flash[:notice]).to eq("#{user.name} wurde erfolgreich gelöscht.")
        end
      end
      context 'users that hold entries' do
        before do
          user.entries << FactoryBot.create(:entry)
          super_admin
        end
        it 'remaining entries get reassigned to superadmin' do
          expect{
            delete :destroy, id: user.id
          }.to change(super_admin.entries, :count).by(+1)
        end
        it 'get deleted' do
          expect{
            delete :destroy, id: user.id
          }.to change(User, :count).by(-1)
        end
        it 'admin gets redirected to user-index and a notification' do
          delete :destroy, id: user.id
          expect(response).to redirect_to(users_path)
          expect(flash[:notice]).to eq("#{user.name} wurde erfolgreich gelöscht. Die Einträge wurden dem Administrator übertragen.")
        end
      end
    end
  end
  context 'as non-admin' do
    subject { delete :destroy, id: user.id }

    it_behaves_like 'something that only admin can access'
  end
end
