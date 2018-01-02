require 'spec_helper'

RSpec.describe AssignmentsController, type: :controller do
  let!(:assignment) { create(:assignment) }
  let!(:admin) { create(:admin) }
  let!(:editor) { create(:editor) }

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
      assignment
      get :edit, id: assignment.to_param
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    before do
      sign_in(admin)
    end
    context 'with valid params' do
      it 'creates a new assignment' do
        expect {
          post :create, assignment: attributes_for(:assignment)
        }.to change(Assignment, :count).by(1)
      end

      it 'shows a notification' do
        post :create, assignment: attributes_for(:assignment)
        expect(flash[:notice]).to eq('Assignment was successfully created.')
      end

      it 'sends an info-mail to assigned user' do
        post :create, assignment: attributes_for(:assignment, assigned_to_user: editor.id)
        expect(ActionMailer::Base.deliveries.last.to).to eq([editor.email])
      end

      it 'redirects to user_entries of assigned user' do
        post :create, assignment: attributes_for(:assignment)
        expect(response).to redirect_to(user_entries_path(Assignment.last.assigned_to_user))
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, assignment: attributes_for(:assignment, assigned_from_user: nil)
        expect(response).to be_success
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :create, assignment: attributes_for(:assignment)
        last_assignment = Assignment.last
        expect(Entry.find(last_assignment.assigned_entry).user_id).to eq(last_assignment.assigned_to_user)
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in(admin)
    end
    context 'with valid params' do
      it 'updates the requested assignment' do
        assignment
        put :update, id: assignment.to_param, assignment: attributes_for(:assignment, assigned_to_date: 1)
        assignment.reload
        expect(assignment.assigned_to_date).not_to eq(Date.today + 3.month)
        expect(assignment.assigned_to_date).to eq(Date.today + 1.month)
      end

      it 'redirects to user_entries of assigned user' do
        put :update, id: assignment.to_param, assignment: attributes_for(:assignment, assigned_to_user: editor.id)
        expect(response).to redirect_to(user_entries_path(editor))
      end

      it 'sends an info-mail to assigned user' do
        put :update, id: assignment.to_param, assignment: attributes_for(:assignment, assigned_to_user: editor.id)
        expect(ActionMailer::Base.deliveries.last.to).to eq([editor.email])
      end
    end
    context 'update user_id in assigned entry' do
      it 'sets user_id in entry to id of assigned user' do
        post :update, id: assignment.to_param, assignment: attributes_for(:assignment, assigned_to_user: editor.id)
        last_assignment = Assignment.last
        expect(Entry.find(last_assignment.assigned_entry).user_id).to eq(last_assignment.assigned_to_user)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        assignment
        put :update, id: assignment.to_param, assignment: attributes_for(:assignment, assigned_from_user: '')
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      before do
        sign_in(admin)
      end
      it 'destroys the requested assignment' do
        assignment
        expect {
          delete :destroy, id: assignment.to_param
        }.to change(Assignment, :count).by(-1)
      end
      it 'redirects to the user entries' do
        assignment
        delete :destroy, id: assignment.to_param
        expect(response).to redirect_to(user_entries_path(assignment.assigned_to_user))
      end
    end
    context 'as editor' do
      before do
        sign_in(editor)
      end
      it 'destroys the requested assignment' do
        assignment
        expect {
          delete :destroy, id: assignment.to_param
        }.to change(Assignment, :count).by(-1)
      end
      it 'sends an info-mail to assignment-creator' do
        assignment.update(assigned_from_user: admin.id)
        delete :destroy, id: assignment.to_param
        expect(ActionMailer::Base.deliveries.last.to).to eq([admin.email])
      end
    end
  end
end
