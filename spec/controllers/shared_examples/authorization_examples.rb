shared_examples_for 'every user can access' do
  context 'as admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as chiefeditor' do
    let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
    before do
      sign_in chiefeditor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    let(:editor) { FactoryGirl.create(:editor) }
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as commentator' do
    let(:editor) { FactoryGirl.create(:editor) }
    before do
      sign_in commentator
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as guest' do
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
end

shared_examples_for 'something that admin, chiefeditor, editor and commentator can access' do
  context 'as admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as chiefeditor' do
    let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
    before do
      sign_in chiefeditor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    let(:editor) { FactoryGirl.create(:editor) }
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as commentator' do
    let(:commentator) { FactoryGirl.create(:commentator) }
    before do
      sign_in commentator
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'when user is a guest' do
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
end

shared_examples_for 'something that admin, chiefeditor & editor can access' do
  context 'as admin' do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as chiefeditor' do
    let(:chiefeditor) { FactoryGirl.create(:chiefeditor) }
    before do
      sign_in chiefeditor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
  context 'as editor' do
    let(:editor) { FactoryGirl.create(:editor) }
    before do
      sign_in editor
    end
    it 'is accessible' do
      subject
      expect(response).to be_success
    end
  end
end

shared_examples_for 'something that only admin can access' do
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
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
end

shared_examples_for 'something that commentator and guest can not access' do
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
    it 'redirects' do
      subject
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Access denied!')
    end
  end
end
