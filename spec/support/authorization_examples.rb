shared_examples_for 'something that a non-admin can not access' do
  context 'when user is a chiefeditor' do
    let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
    before do
      sign_in chiefeditor 
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
  context 'when user is a editor' do
    let(:editor) { FactoryGirl.create(:editor) }
    before do
      sign_in editor 
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
  context 'when user is a commentator' do
    let(:commentator) { FactoryGirl.create(:commentator) }
    before do
      sign_in commentator 
    end
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
  context 'when user is a guest' do
    let(:guest) { FactoryGirl.create(:guest) }
    it 'redirects' do
      subject
      expect(response).to redirect_to(user_session_path)
    end
  end
end
