require 'spec_helper'

RSpec.describe AssignmentsHelper, type: :helper do
  let(:assigned_entry) { create(:entry) }
  let(:assignment_creator) { create(:admin) }
  let(:assignment_recipient) { create(:editor) }
  let(:assignment) { create(:assignment) }

  describe 'entry' do
    it 'returns assigned entry' do
      assignment.update(assigned_entry: assigned_entry.id)
      expect(assignment.entry).to eq(assigned_entry)
    end
  end
  describe 'name_of_recipient' do
    it 'returns name of assigned user' do
      assignment.update(assigned_to_user: assignment_recipient.id)
      expect(assignment.name_of_recipient).to eq(assignment_recipient.name)
    end
  end
  describe 'email_of_recipient' do
    it 'returns name of assigned user' do
      assignment.update(assigned_to_user: assignment_recipient.id)
      expect(assignment.email_of_recipient).to eq(assignment_recipient.email)
    end
  end
  describe 'name_of_creator' do
    it 'returns name of creator of assignment' do
      assignment.update(assigned_from_user: assignment_creator.id)
      expect(assignment.name_of_creator).to eq(assignment_creator.name)
    end
  end
  describe 'email_of_creator' do
    it 'returns email of creator of task' do
      assignment.update(assigned_from_user: assignment_creator.id)
      expect(assignment.email_of_creator).to eq(assignment_creator.email)
    end
  end
end
