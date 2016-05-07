require 'spec_helper'

describe EntriesController, :type => :controller do

  let(:entry) { FactoryGirl.create(:entry) }
  let(:unpublished_entry) { FactoryGirl.create(:entry) }
  let(:published_entry) { FactoryGirl.create(:published_entry) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    admin
    editor
  end

  # describe "GET index" do
  #   it "returns published entries" do
  #     pending("tdd?, test does not run")
  #     published_entry
  #     get :index
  #     expect(assigns(:entries)).to include(published_entry)
  #   end
  #   it "does not returns unpublished entries" do
  #     pending("tdd?, test does not run")
  #     unpublished_entry 
  #     get :index
  #     expect(assigns(:entries)).not_to include(published_entry)
  #   end
  # end

  describe 'get index' do
    context 'as admin' do
      it 'shows user index' do
        sign_in admin
        get :index
        expect(response).to be_success
      end
      it 'sorts the index in the right way' do
        pending('todo')
        raise
      end
      it 'shows the right search results' do
        pending('todo')
        raise
      end
    end
  end

  describe "GET show" do
    before :each do
      unpublished_entry 
      published_entry
    end

    it "shows published entries" do
      sign_in editor
      get :show, id: published_entry.id
      expect(assigns(:entry)).to eq(published_entry)
      expect(response).to be_success
      expect(response).to render_template :show
    end

    it "does not show an unpublished entry" do
      pending("tdd? there is no redirect case in the controller")
      sign_in editor
      get :show, id: unpublished_entry.id
      expect(response).to redirect_to(entries_url)
      # expect(response).to redirect_to(entries_path)
    end

  end

  describe "GET new" do
    it "assigns a new entry as @entry" do
      sign_in admin
      get :new
      expect(assigns(:entry)).to be_a_new(Entry)
    end
  end

  describe "GET edit" do
    before :each do
      unpublished_entry
    end
    it "assigns the requested entry as @entry" do
      sign_in editor
      unpublished_entry.user_id = editor.id
      unpublished_entry.reload
      get :edit, id: unpublished_entry.id
      expect(assigns(:entry)).to eq(unpublished_entry)
    end
  end

  describe "POST create" do
    context "as admin" do
      before do
        sign_in admin 
      end
      context "for herself" do
        it "creates an entry" do
          attributes = FactoryGirl.attributes_for(:entry, user_id: admin.id) 
          expect {
            post :create, entry: attributes
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(admin)
          end
        end
        it "and gets redirects to the it" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: admin.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context "for somebody else" do
        it "creates an entry" do
          editor 
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it "and gets redirects to the it" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
    end
    context "chiefeditor" do
      before do
        sign_in chiefeditor 
      end
      context "for herself" do
        it "creates an entry" do
          attributes = FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id) 
          expect {
            post :create, entry: attributes
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(chiefeditor)
          end
        end
        it "and gets redirects to the it" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context "for somebody else" do
        it "creates an entry" do
          editor 
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it "and gets redirects to the it" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
    end
    context "editor" do
      before do
        sign_in editor 
      end
      context "for herself" do
        it "creates an entry" do
          attributes = FactoryGirl.attributes_for(:entry, user_id: editor.id) 
          expect {
            post :create, entry: attributes
          }.to change(Entry, :count).by(1)
          assigns(:entry).tap do |entry|
            expect(entry.user).to eq(editor)
          end
        end
        it "and gets redirects to the it" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
          expect(response).to redirect_to(Entry.last)
        end
      end
      context "for somebody else" do
        it "does not creates an entry" do
          editor 
          expect {
            post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          }.to change(Entry, :count).by(0)
          end
        end
        it "and gets redirects to the new template" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          expect(response).to be_redirect
        end
        it "and gets this error-message" do
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: chiefeditor.id)
          expect(flash[:notice]).to eq('as editor you are not allowed to create an entry for somebody else' )
        end
      end
    subject { post :create, entry: FactoryGirl.attributes_for(:entry) } 

    it_behaves_like 'something that only admin, chiefeditor & editor can access'
  end


  describe 'get update' do
    context 'admin' do
      before do
        sign_in admin 
      end
      context 'for himself' do
        before do
          modified_entry_user_id = admin.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'updates an entry' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'and redirect to it' do
          expect(response).to redirect_to(entry)
        end
      end
      context 'for somebody else' do
        before do
          modified_entry_user_id = editor.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'updates an entry' do
          expect(entry.japanische_umschrift).to eq('some editing on somebody else\'s entry')
        end
        it 'and redirects to it' do
          expect(response).to redirect_to(entry)
        end
      end
    end
    context 'chiefeditor' do
      before do
        sign_in chiefeditor 
      end
      context 'for himself' do
        before do
          modified_entry_user_id = chiefeditor.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'updates an entry' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'and redirect to it' do
          expect(response).to redirect_to(entry)
        end
      end
      context 'for somebody else' do
        before do
          modified_entry_user_id = admin.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'updates an entry' do
          expect(entry.japanische_umschrift).to eq('some editing on somebody else\'s entry')
        end
        it 'and redirects to it' do
          expect(response).to redirect_to(entry)
        end
      end
    end

    context 'editor' do
      before do
        sign_in editor
      end
      context 'for himself' do
        before do
          modified_entry_user_id = editor.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on my own entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'updates an entry' do
          expect(entry.japanische_umschrift).to eq('some editing on my own entry')
        end
        it 'and redirect to it' do
          expect(response).to redirect_to(entry)
        end
      end
      context 'for somebody else' do
        before do
          modified_entry_user_id = chiefeditor.id
          put :update, id: entry.id, entry: { japanische_umschrift: 'some editing on somebody else\'s entry', user_id: modified_entry_user_id }
          entry.reload
        end
        it 'does not updates an entry' do
          expect(entry.japanische_umschrift).not_to eq('some editing on somebody else\'s entry')
        end
        it 'and gets redirected' do
          expect(response).to be_redirect
        end
        it 'and gets this error-message' do
          expect(flash[:notice]).to eq('as editor you are not allowed to edit somebody else\'s entry' )
        end
      end
    end
    subject { put :update, id: entry.id, entry: { japanische_umschrift: 'different_content' } }

    it_behaves_like 'something that only admin, chiefeditor & editor can access'
 end

  describe "DELETE destroy" do
    before do
      published_entry
    end

    it "destroys the requested entry" do
      sign_in admin
      expect {
        delete :destroy, id: published_entry.id
      }.to change(Entry, :count).by(-1)
      sign_out admin
    end

    it "redirects to the entries list" do
      sign_in admin
      delete :destroy, id: published_entry.id
      expect(response).to redirect_to(entries_path)
      sign_out admin
    end
  end
end
