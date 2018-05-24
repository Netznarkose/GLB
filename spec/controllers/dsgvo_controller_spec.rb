require 'spec_helper'

RSpec.describe DsgvoController, type: :controller do
  let(:admin) { create(:admin) }

  describe 'GET #welcome' do
    it 'returns http success' do
      get :welcome
      expect(response).to have_http_status(:success)
    end

    context 'logged in users' do
      before do
        sign_in admin
      end
      it 'get redirected to entry index' do
        get :welcome
        expect(response).to redirect_to(entries_path)
      end
    end
    context 'guests' do
      it 'get directed to dsgvo#welcome' do
        get :welcome
        expect(response).to render_template('dsgvo/welcome')
      end
    end
  end
end
