require 'spec_helper'

RSpec.describe EntryVersion, type: :model do
  let(:entry) { create(:entry) }
  let(:admin) { create(:admin) }

  describe 'user_name' do
    context 'if db holds related editor' do
      it 'returns name of editor' do
        entry.update(user_id: admin.id)
        last_version = entry.versions.last
        last_version.update(whodunnit: admin.id)
        expect(last_version.user_name).to eq(admin.name)
      end
    end
    context 'if db does not holds related user' do
      it 'returns nil' do
        entry.update(user_id: admin.id)
        last_version = entry.versions.last
        last_version.update(whodunnit: 23)
        expect(last_version.user_name).to eq(nil)
      end
    end
  end
end
