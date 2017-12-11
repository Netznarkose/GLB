require 'spec_helper'

RSpec.describe TasksController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }
  let!(:task) { create(:task) }
  let!(:admin) { create(:admin) }


  before do
    sign_in(admin)
  end
  describe "GET #index" do
    it "returns a success response" do
      task
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      task
      get :show, {:id => task.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      task
      get :edit, {:id => task.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, task: attributes_for(:task)
        }.to change(Task, :count).by(1)
      end

      it "redirects to the created task" do
        post :create, { task: attributes_for(:task) }
        expect(response).to redirect_to(Task.last)
      end
    end

    context "with invalid params" do
      xit "returns a success response (i.e. to display the 'new' template)" do
        post :create, { task: attributes_for(:task, assigned_entry: nil) }
        expect(response).to be_success
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :create, { task: attributes_for(:task) }
        last_task = Task.last
        expect(Entry.find(last_task.assigned_entry).user_id).to eq(last_task.assigned_to_user)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested task" do
        task
        put :update, {:id => task.to_param, :task => attributes_for(:task, assigned_to_date: Date.today + 1.month) }
        task.reload
        expect(task.assigned_to_date).not_to eq(Date.today + 3.month)
        expect(task.assigned_to_date).to eq(Date.today + 1.month)
      end

      it "redirects to the task" do
        task
        put :update, {:id => task.to_param, :task => attributes_for(:task, assigned_to_date: Date.today + 1.month) }
        expect(response).to redirect_to(task)
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :create, { task: attributes_for(:task) }
        last_task = Task.last
        expect(Entry.find(last_task.assigned_entry).user_id).to eq(last_task.assigned_to_user)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        task = Task.create! valid_attributes
        put :update, {:id => task.to_param, :task => invalid_attributes}, valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = Task.create! valid_attributes
      expect {
        delete :destroy, {:id => task.to_param}, valid_session
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = Task.create! valid_attributes
      delete :destroy, {:id => task.to_param}, valid_session
      expect(response).to redirect_to(tasks_url)
    end
  end

end
