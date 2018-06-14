require 'spec_helper'

RSpec.describe Entry, type: :model do
  let(:entry) { create(:entry) }
  let(:assignment) { create(:assignment) }

  describe 'general' do
    it 'creates a new instance of an entry given valid attributes' do
      expect(entry).to be_persisted
      expect(entry).to be_valid
    end
  end

  describe 'destroy_related_assignment' do
    context 'with assignment' do
      before do
        assignment.update(entry_id: entry.id)
      end
      it 'destroys it' do
        expect(Assignment.where(id: assignment.id).first).to eq(assignment)
        entry.destroy_related_assignment
        expect(Assignment.where(id: assignment.id).first).to eq(nil)
      end
    end
    context 'without assignment' do
      it 'does not raise an error' do
        expect{ entry.destroy_related_assignment }.not_to raise_error
      end
    end
  end
end
