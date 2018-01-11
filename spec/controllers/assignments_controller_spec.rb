require 'spec_helper'

RSpec.describe AssignmentsController, type: :controller do
  let(:assignment) { create(:assignment) }
  let(:admin) { build(:admin) }
  let(:editor) { build(:editor) }
  let(:author) { build(:author) }
  let(:commentator) { build(:commentator) }
  let(:user) { build(:user) }

  describe 'GET #new' do
    subject {get :new}
    it_behaves_like 'something that only admin can access'
  end

  describe 'GET #edit' do
    before do
      assignment
    end
    subject { get :edit, id: assignment.to_param }
    it_behaves_like 'something that only admin can access'
  end

  describe 'POST #create' do
    subject { post :create, assignment: attributes_for(:assignment) }
    it_behaves_like 'something that only admin can access'

    context 'as admin' do
      before do
        admin.save
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
          editor.save
          post :create, assignment: attributes_for(:assignment, recipient_id: editor.id)
          expect(ActionMailer::Base.deliveries.last.to).to eq([editor.email])
        end

        it 'redirects to user_entries of assigned user' do
          post :create, assignment: attributes_for(:assignment)
          expect(response).to redirect_to(user_entries_path(Assignment.last.recipient_id))
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, assignment: attributes_for(:assignment, creator_id: nil)
          expect(response).to be_success
        end
      end
      context 'update user_id in assigned entry' do
        it 'sets user_id in entry to id of assigned user' do
          post :create, assignment: attributes_for(:assignment)
          last_assignment = Assignment.last
          expect(Entry.find(last_assignment.entry_id).user_id).to eq(last_assignment.recipient_id)
        end
      end
    end
  end

  describe 'PUT #update' do
    subject { put :update, id: assignment.to_param, assignment: attributes_for(:assignment, to_date: 1) }
    it_behaves_like 'something that only admin can access'
    context 'as admin' do
      before do
        admin.save
        editor.save
        sign_in(admin)
      end
      context 'with valid params' do
        it 'updates the requested assignment' do
          assignment
          put :update, id: assignment.to_param, assignment: attributes_for(:assignment, to_date: 1)
          assignment.reload
          expect(assignment.to_date).not_to eq(Date.today + 3.month)
          expect(assignment.to_date).to eq(Date.today + 1.month)
        end

        it 'redirects to user_entries of assigned user' do
          put :update, id: assignment.to_param, assignment: attributes_for(:assignment, recipient_id: editor.id)
          expect(response).to redirect_to(user_entries_path(editor))
        end

        it 'sends an info-mail to assigned user' do
          put :update, id: assignment.to_param, assignment: attributes_for(:assignment, recipient_id: editor.id)
          expect(ActionMailer::Base.deliveries.last.to).to eq([editor.email])
        end
      end
      context 'update user_id in assigned entry' do
        it 'sets user_id in entry to id of assigned user' do
          post :update, id: assignment.to_param, assignment: attributes_for(:assignment, recipient_id: editor.id)
          last_assignment = Assignment.last
          expect(Entry.find(last_assignment.entry_id).user_id).to eq(last_assignment.recipient_id)
        end
      end

      context 'with invalid params' do
        it "returns a success response (i.e. to display the 'edit' template)" do
          assignment
          put :update, id: assignment.to_param, assignment: attributes_for(:assignment, creator_id: '')
          expect(response).to be_success
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, id: assignment.to_param }
    it_behaves_like 'something that commentator and guest can not access'
    context 'as admin' do
      before do
        admin.save
        sign_in(admin)
      end
      it 'destroys the requested assignment' do
        assignment
        expect {
          delete :destroy, id: assignment.to_param
        }.to change(Assignment, :count).by(-1)
      end
      it 'shows correct notification-message' do
        delete :destroy, id: assignment.to_param
        expect(flash[:notice]).to eq('Der Eintrag wurde mit erledigt markiert.')
      end
      it 'redirects to the user entries' do
        assignment
        delete :destroy, id: assignment.to_param
        expect(response).to redirect_to(user_entries_path(assignment.recipient_id))
      end
    end
  end
end
