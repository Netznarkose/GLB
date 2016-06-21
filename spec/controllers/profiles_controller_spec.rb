require 'spec_helper'

describe ProfilesController, type: :controller do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:author) { FactoryGirl.create(:author) }
  let(:user) { FactoryGirl.create(:user) }
  let(:guest) { FactoryGirl.create(:guest) }

  describe 'get edit' do
    context 'as logged-in user' do
      before do
        sign_in author
      end
      it 'renders the view' do
        get :edit, id: author.id
        expect(response).to render_template(:edit)
      end
    end
    context 'as non-logged-in user' do
      it 'does not render the view' do
        get :edit, id: author.id
        expect(response).not_to render_template(:edit)
      end
    end
  end

  describe 'get update' do
    context 'as logged-in user' do
      before do
        sign_in admin
      end
      context 'with valid attributes' do
        before do
          put :update, id: admin.id, user: { name: 'different_author name',
                                             email: 'different_author@user.com' }
          admin.reload
        end
        it 'updates name & email' do
          expect(admin.name).to eq('different_author name')
          expect(admin.email).to eq('different_author@user.com')
        end
        it 'returns a confirmation-message' do
          expect(flash[:notice]).to eq('profile updated')
        end
      end
      context 'with invalid attributes' do
        before do
          put :update, id: author.id, user: { email: '' }
          author.reload
        end
        it 'redirects to the edit-view' do
          expect(response).not_to render_template(:edit)
        end
        it 'returns an error-message' do
          expect(flash[:notice]).to eq('Access denied!')
        end
      end
    end
    context 'as logged-in user' do
      before do
        sign_in admin
      end
      it 'I can not update update somebody else\'s profile' do
        put :update, id: author.id, user: { name: 'different_author name' }
        author.reload
        expect(author.name).not_to eq('different_author name')
        expect(author.name).to eq(author.name)
      end
    end
    context 'as not logged-in user' do
      it 'I can not update somebody else\'s profile' do
        put :update, id: author.id, user: { name: 'different_author name' }
        author.reload
        expect(author.name).not_to eq('different_author name')
        expect(author.name).to eq(author.name)
      end
    end
    context 'as guest' do
      before do
        sign_in guest
      end
      it 'I can not update somebody else\'s profile' do
        put :update, id: author.id, user: { name: 'different_author name' }
        author.reload
        expect(author.name).not_to eq('different_author name')
        expect(author.name).to eq(author.name)
      end
    end
  end
end
