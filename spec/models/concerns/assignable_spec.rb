require 'spec_helper'

RSpec.describe Assignable, type: :concern do
  let(:entry) { create(:entry) }
  let(:entry_with_assignment) { create(:entry) }
  let!(:assignment) { create(:assignment, entry_id: entry_with_assignment.id) }

  describe '#assignment' do
    it 'fetches attached assignment' do
      expect(entry_with_assignment.assignment).to eq(assignment)
    end
  end
  describe 'destroy_related_assignment' do
    context 'with assignment' do
      it 'destroys it' do
        expect(entry_with_assignment.assignment.present?).to eq(true)
        entry_with_assignment.destroy_related_assignment
        expect(entry_with_assignment.assignment.present?).to eq(false)
      end
    end
    context 'without assignment' do
      it 'returns nil and does not raise an error' do
        expect(entry.destroy_related_assignment).to eq(nil)
        expect { entry.destroy_related_assignment }.not_to raise_error
      end
    end
  end
end
