require 'spec_helper'

RSpec.describe TasksController, type: :controller do
  let!(:task) { create(:task) }
  let!(:admin) { create(:admin) }
  let!(:editor) { create(:editor) }

  describe 'GET #index' do
    before do
      sign_in(admin)
    end
    it 'returns a success response' do
      task
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    before do
      sign_in(admin)
    end
    it 'returns a success response' do
      task
      get :show, id: task.to_param
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    before do
      sign_in(admin)
    end
    it 'returns a success response' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    before do
      sign_in(admin)
    end
    it 'returns a success response' do
      task
      get :edit, id: task.to_param
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    before do
      sign_in(admin)
    end
    context 'with valid params' do
      it 'creates a new Task' do
        expect {
          post :create, task: attributes_for(:task)
        }.to change(Task, :count).by(1)
      end

      it 'shows a notification' do
        post :create, task: attributes_for(:task)
        expect(flash[:notice]).to eq('Task was successfully created.')
      end

      xit 'sends an info-mail to assigned user' do
        post :create, task: attributes_for(:task)
        expect(ActionMailer::Base.deliveries.last.to).to eq([task.email_of_assigned_user])
      end

      it 'redirects to user_entries of assigned user' do
        post :create, task: attributes_for(:task)
        expect(response).to redirect_to(user_entries_path(Task.last.assigned_to_user))
      end
      it 'redirects to user_entries of assigned user' do
        post :create, task: attributes_for(:task)
        expect(response).to redirect_to(user_entries_path(Task.last.assigned_to_user))
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, task: attributes_for(:task, assigned_from_user: nil)
        expect(response).to be_success
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :create, task: attributes_for(:task)
        last_task = Task.last
        expect(Entry.find(last_task.assigned_entry).user_id).to eq(last_task.assigned_to_user)
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in(admin)
    end
    context 'with valid params' do
      it 'updates the requested task' do
        task
        put :update, id: task.to_param, task: attributes_for(:task, assigned_to_date: 1)
        task.reload
        expect(task.assigned_to_date).not_to eq(Date.today + 3.month)
        expect(task.assigned_to_date).to eq(Date.today + 1.month)
      end

      it 'redirects to user_entries of assigned user' do
        put :update, id: task.to_param, task: attributes_for(:task, assigned_to_date: Date.today + 1.month)
        expect(response).to redirect_to(user_entries_path(Task.last.assigned_to_user))
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :create, task: attributes_for(:task)
        last_task = Task.last
        expect(Entry.find(last_task.assigned_entry).user_id).to eq(last_task.assigned_to_user)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        task
        put :update, id: task.to_param, task: attributes_for(:task, assigned_from_user: '')
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      before do
        sign_in(admin)
      end
      it 'destroys the requested task' do
        task
        expect {
          delete :destroy, id: task.to_param
        }.to change(Task, :count).by(-1)
      end
      it 'redirects to the user entries' do
        task
        delete :destroy, id: task.to_param
        expect(response).to redirect_to(user_entries_path(task.assigned_to_user))
      end
    end
    context 'as editor' do
      before do
        sign_in(editor)
      end
      it 'destroys the requested task' do
        task
        expect {
          delete :destroy, id: task.to_param
        }.to change(Task, :count).by(-1)
      end
    end
  end
end
