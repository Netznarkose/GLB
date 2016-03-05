require 'spec_helper'

# I'm a public user No ability to create
# I'm an editor
# I'm an admin
# I create an Entry for myself
# I create an Entry for other person


describe EntriesController, :type => :controller do

  let(:unpublished_entry) { FactoryGirl.create(:entry) }
  let(:published_entry) { FactoryGirl.create(:published_entry) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:editor) { FactoryGirl.create(:editor) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    admin
    editor
  end

  describe "GET index" do
    it "returns published entries" do
      pending("tdd?, test does not run")
      published_entry
      get :index
      expect(assigns(:entries)).to include(published_entry)
    end
    it "does not returns unpublished entries" do
      pending("tdd?, test does not run")
      unpublished_entry 
      get :index
      expect(assigns(:entries)).not_to include(published_entry)
    end
  end

  describe "GET show" do
    before :each do
      unpublished_entry 
      published_entry
    end

    it "doesn't show only published entries" do
    # it "does not show an unpublished entry ???" do
      pending("tdd? there is no redirect case in the controller")
      sign_in editor
      get :show, id: unpublished_entry.id
      expect(response).to redirect_to(entries_url)
      # expect(response).to redirect_to(entries_path)
    end

    it "shows published entries" do
      sign_in editor
      get :show, id: published_entry.id
      expect(assigns(:entry)).to eq(published_entry)
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
    context "Admin is able to creates an entry" do
      before :each do
        sign_in admin
      end

      it "for herself" do
        attributes = FactoryGirl.attributes_for(:entry, user_id: nil) 
        expect {
          post :create, entry: attributes
        }.to change(Entry, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(admin)
        end
      end

      it "for an editor" do
        editor 
        expect {
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
        }.to change(Entry, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(editor)
        end
      end

      it "another admin" do
        admin 
        expect {
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: admin.id)
        }.to change(Entry, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(admin)
        end
      end
      
      it "and gets redirects to the created entry" do
        post :create, entry: FactoryGirl.attributes_for(:entry)
        expect(response).to redirect_to(Entry.last)
      end
    end
    context "Editor is able to creates an entry" do
      before :each do
        sign_in editor
      end

      it "for herself" do
        attributes = FactoryGirl.attributes_for(:entry, user_id: nil) 
        expect {
          post :create, entry: attributes
        }.to change(Entry, :count).by(1)

        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(editor)
        end
      end
      it "for another editor" do
        editor 
        expect {
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: editor.id)
        }.to change(Entry, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(editor)
        end
      end
      it "an admin" do
        admin 
        expect {
          post :create, entry: FactoryGirl.attributes_for(:entry, user_id: admin.id)
        }.to change(Entry, :count).by(1)
        assigns(:entry).tap do |entry|
          expect(entry.user).to eq(admin)
        end
      end
      it "and gets redirects to the created entry" do
        post :create, entry: FactoryGirl.attributes_for(:entry)
        expect(response).to redirect_to(Entry.last)
      end
    end
    context "User" do
      it "is not able to create an entry and gets redirected" do
        pending('restricted by cancancan')
        sign_in user
        attributes = FactoryGirl.attributes_for(:entry)
        attributes.delete(:user_id)
        post :create, :entry => attributes
        # expect(response).to be_redirect
        expect(response.code).to eq(302.to_s)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


  describe "PUT update" do
    describe "with valid params" do
      pending
      it "updates the requested entry" do
        entry = Entry.create! FactoryGirl.attributes_for(:entry)
        # Assuming there are no other entries in the database, this
        # specifies that the Entry created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Entry.any_instance.should_receive(:update_attributes).with({ "verfasser" => "MyString" })
        put :update, {:id => entry.to_param, :entry => { "verfasser" => "MyString" }}
      end

      it "assigns the requested entry as @entry" do
        entry = Entry.create! FactoryGirl.attributes_for(:entry)
        put :update, {:id => entry.to_param, :entry => FactoryGirl.attributes_for(:entry)}
        subject { assigns(:entry) }
        it {is_expected.to eq(entry) }
      end

      it "redirects to the entry" do
        entry = Entry.create! FactoryGirl.attributes_for(:entry)
        put :update, {:id => entry.to_param, :entry => FactoryGirl.attributes_for(:entry)}
        expect(response).to redirect_to(entry)
      end
    end

    describe "with invalid params" do
      it "assigns the entry as @entry" do
        sign_in @admin
        # Trigger the behavior that occurs when invalid params are submitted
        Entry.any_instance.stub(:save).and_return(false)
        put :update, {:id => @entry.to_param, :entry => { "namenskuerzel" => "invalid value" }}
        assigns(:entry).should eq(@entry)
        sign_out @admin
      end

      it "re-renders the 'edit' template" do
        sign_in @admin
        # Trigger the behavior that occurs when invalid params are submitted
        Entry.any_instance.stub(:save).and_return(false)
        put :update, {:id => @entry.to_param, :entry => { "namenskuerzel" => "invalid value" }}
        response.should render_template("edit")
        sign_out @admin
      end
    end
  end

  describe "DELETE destroy" do
    before do
      published_entry
    end

    it "destroys the requested entry" do
      sign_in @admin
      expect {
        delete :destroy, id: published_entry.id
      }.to change(Entry, :count).by(-1)
      sign_out @admin
    end

    it "redirects to the entries list" do
      sign_in @admin
      delete :destroy, id: published_entry.id
      response.should redirect_to(entries_path)
      sign_out @admin
    end
  end

end
