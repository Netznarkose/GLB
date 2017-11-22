require 'spec_helper'

describe EntryVersionsController, type: :controller do
  let(:entry) { FactoryBot.create(:entry) }
  let(:admin) { FactoryBot.create(:admin) }

  before :each do
    admin
    sign_in admin
  end

  describe 'get index' do
    it 'shows user index' do
      get :index, entry_id: entry.id
      expect(response).to be_success
    end
  end
  describe "GET #show" do
    it "returns http success" do
      get :show, entry_id: entry.id, id: 1 
      expect(response).to have_http_status(:success)
    end
  end

end
