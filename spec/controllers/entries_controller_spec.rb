require 'spec_helper'

describe EntriesController, type: :controller do
  let(:entry) { FactoryGirl.create(:entry) }
  let(:unpublished_entry) { FactoryGirl.create(:entry) }
  let(:published_entry) { FactoryGirl.create(:published_entry) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:commentator) { FactoryGirl.create(:commentator) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    admin
    editor
  end

  describe 'Get index' do
    subject { get :index }
    it_behaves_like 'every user can access'
  end

  describe 'GET show' do
    before do
      unpublished_entry
      published_entry
    end
    context 'as admin, chiefeditor and editor' do
      context 'published entries' do
        subject { put :show, id: published_entry.id }
        it_behaves_like 'something that admin, chiefeditor & editor can access'
      end
      context 'unpublished entries' do
        subject { put :show, id: unpublished_entry.id }
        it_behaves_like 'something that admin, chiefeditor & editor can access'
      end
    end
    context 'as commentator' do
      before do
        sign_in commentator
      end
      context 'published entries' do
        it 'is accessible' do
          get :show, id: published_entry.id
          expect(response).to render_template :show
        end
      end
      context 'unpublished entries' do
        it 'is not accessible' do
          get :show, id: unpublished_entry.id
          expect(response).not_to render_template :show
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
    context 'as guest' do
      context 'published entries' do
        it 'is accessible' do
          get :show, id: published_entry.id
          expect(response).to render_template :show
        end
      end
      context 'unpublished entries' do
        it 'is not accessible' do
          get :show, id: unpublished_entry.id
          expect(response).not_to render_template :show
          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
  end

  describe 'GET new' do
    it 'assigns a new entry as @entry' do
      sign_in admin
      get :new
      expect(assigns(:entry)).to be_a_new(Entry)
    end
    context 'as admin, chiefeditor and editor' do
      subject { get :new }

      it_behaves_like 'something that admin, chiefeditor & editor can access'
    end
    context 'as commentator and guest' do
      subject { get :new }

      it_behaves_like 'something that commentator and guest can not access'
    end
  end

  describe 'GET edit' do
    before do
      entry
    end
    it 'assigns the requested entry as @entry' do
      sign_in admin
      get :edit, id: entry.id
      expect(assigns(:entry)).to eq(entry)
    end
    context 'as admin, chiefeditor and editor' do
      subject { get :edit, id: entry.id }

      it_behaves_like 'something that admin, chiefeditor & editor can access'
    end
    context 'as commentator and guest' do
      subject { get :edit, id: entry.id }

      it_behaves_like 'something that commentator and guest can not access'
    end
  end

  describe 'POST create' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'for herself' do
        it 'creates an entry' do
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: admin.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(admin)
          end
        end
        it 'and gets redirects to the it' do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: admin.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context 'for somebody else' do
        it 'creates an entry' do
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it 'and gets redirects to the it' do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
    end
    context 'chiefeditor' do
      before do
        sign_in chiefeditor
      end
      context 'for herself' do
        it 'creates an entry' do
          expect {
            post :create, entry: attributes = FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(chiefeditor)
          end
        end
        it 'and gets redirects to the it' do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context 'for somebody else' do
        it 'creates an entry' do
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it 'and gets redirects to the it' do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
    end
    context 'editor' do
      before do
        sign_in editor
      end
      context 'for herself' do
        it 'creates an entry' do
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it 'and gets redirects to the it' do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context 'for somebody else' do
        it 'does not creates an entry' do
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          }.to change(Entry, :count).by(0)
        end
      end
      it 'gets redirects to the root path' do
        post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
        expect(response).to redirect_to(root_path)
      end
      it 'and gets an error-message' do
        post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
        expect(flash[:notice]).to eq('Access denied!')
      end
    end
    subject { post :create, entry: FactoryGirl.attributes_for(:entry) }

    it_behaves_like 'something that commentator and guest can not access'
  end

  describe 'Get update' do
    context 'admin' do
      before do
        sign_in admin
      end
      context 'own entry' do
        before do
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: admin.id }
          entry.reload
        end
        it 'gets updated' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'gets redirect to it' do
          expect(response).to redirect_to(entry)
        end
        it 'and gets a notification' do
          expect(flash[:notice]).not_to be_empty
        end
      end
      context 'other users entry' do
        before do
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: editor.id }
          entry.reload
        end
        it 'gets updated' do
          expect(entry.japanische_umschrift).to eq('some editing on somebody else\'s entry')
        end
        it 'gets redirect to it' do
          expect(response).to redirect_to(entry)
        end
        it 'and gets a notification' do
          expect(flash[:notice]).not_to be_empty
        end
      end
    end
    context 'chiefeditor' do
      before do
        sign_in chiefeditor
      end
      context 'own entry' do
        before do
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: chiefeditor.id }
          entry.reload
        end
        it 'gets updated' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'gets redirect to it' do
          expect(response).to redirect_to(entry)
        end
        it 'and gets a notification' do
          expect(flash[:notice]).not_to be_empty
        end
      end
      context 'other users entry' do
        before do
          somebody_elses__user_id = admin.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: somebody_elses__user_id }
          entry.reload
        end
        it 'gets updated' do
          expect(entry.japanische_umschrift).to eq('some editing on somebody else\'s entry')
        end
        it 'gets redirect to it' do
          expect(response).to redirect_to(entry)
        end
        it 'and gets a notification' do
          expect(flash[:notice]).not_to be_empty
        end
      end
    end
    context 'editor' do
      before do
        sign_in editor
      end
      context 'own entry' do
        before do
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: editor.id }
          entry.reload
        end
        it 'gets updated' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'gets redirect to it' do
          expect(response).to redirect_to(entry)
        end
        it 'and gets a notification' do
          expect(flash[:notice]).not_to be_empty
        end
      end
      context 'other users entry' do
        before do
          somebody_elses_user_id = chiefeditor.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: somebody_elses_user_id }
          entry.reload
        end
        it 'does not get updated' do
          expect(entry.japanische_umschrift).not_to eq('some editing on somebody else\'s entry')
        end
        it 'gets redirected' do
          expect(response).to redirect_to(root_path)
        end
        it 'and gets an error-message' do
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
    subject { put :update, id: entry.id, entry: { japanische_umschrift: 'different_content' } }

    it_behaves_like 'something that commentator and guest can not access'
  end

  describe 'DELETE destroy' do
    context 'as admin' do
      before do
        sign_in admin
      end
      context 'own entries' do
        before do
          entry
          entry.update(user_id: admin.id)
        end
        it 'can be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(-1)
        end
        it 'gets redirected to entries-index' do
          delete :destroy, id: entry.id
          expect(response).to redirect_to(entries_path)
        end
      end
      context 'other users entries' do
        before do
          entry
          entry.update(user_id: editor.id)
        end
        it 'can be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(-1)
        end
        it 'gets redirected to entries-index' do
          delete :destroy, id: entry.id
          expect(response).to redirect_to(entries_path)
        end
      end
    end
    context 'as chiefeditor' do
      before do
        sign_in chiefeditor
      end
      context 'own entries' do
        before do
          entry
          entry.update(user_id: chiefeditor.id)
        end
        it 'can be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(-1)
        end
        it 'gets redirected to entries-index' do
          delete :destroy, id: entry.id
          expect(response).to redirect_to(entries_path)
        end
      end
      context 'other users entries' do
        before do
          entry
          entry.update(user_id: editor.id)
        end
        it 'can be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(-1)
        end
        it 'gets redirected to entries-index' do
          delete :destroy, id: entry.id
          expect(response).to redirect_to(entries_path)
        end
      end
    end
    context 'as editor' do
      before do
        sign_in editor
      end
      context 'own entries' do
        before do
          entry
          entry.update(user_id: editor.id)
        end
        it 'can be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(-1)
        end
        it 'gets redirected to entries-index' do
          delete :destroy, id: entry.id
          expect(response).to redirect_to(entries_path)
        end
      end
      context 'other users entries' do
        before do
          entry
          entry.update(user_id: chiefeditor.id)
        end
        it 'can not be deleted' do
          expect {
            delete :destroy, id: entry.id
          }.to change(Entry, :count).by(0)
        end
        it 'and gets redirected' do
          delete :destroy, id: entry.id
          expect(response).to be_redirect
        end
        it 'gets an error-message' do
          delete :destroy, id: entry.id
          expect(flash[:notice]).to eq('as editor you are not allowed to delete somebody else\'s entry')
        end
      end
    end
    subject { put :destroy, id: entry.id }

    it_behaves_like 'something that commentator and guest can not access'
  end
end
