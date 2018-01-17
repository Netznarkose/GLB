require 'spec_helper'

RSpec.describe UserEntriesController, type: :controller do
  let(:admin) { create(:admin) }

  describe 'Get index' do
    it 'renders the index-template' do
      get :index, user_id: admin.id
      expect(response).to be_success
    end
  end

end
