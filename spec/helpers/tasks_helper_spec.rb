require 'spec_helper'

RSpec.describe TasksHelper, type: :helper do
  let(:assigned_entry) { create(:entry) }
  let(:task_creator) { create(:admin) }
  let(:assigned_user) { create(:editor) }
  let(:task) { create(:task) }

  describe 'entry' do
    it 'returns assigned entry' do
      task.update(assigned_entry: assigned_entry.id)
      expect(task.entry).to eq(assigned_entry)
    end
  end
  describe 'name_of_assigned_user' do
    it 'returns name of assigned user' do
      task.update(assigned_to_user: assigned_user.id)
      expect(task.name_of_assigned_user).to eq(assigned_user.name)
    end
  end
  describe 'email_of_assigned_user' do
    it 'returns name of assigned user' do
      task.update(assigned_to_user: assigned_user.id)
      expect(task.email_of_assigned_user).to eq(assigned_user.email)
    end
  end
  describe 'name_of_task_creator' do
    it 'returns name of creator of task' do
      task.update(assigned_from_user: task_creator.id)
      expect(task.name_of_task_creator).to eq(task_creator.name)
    end
  end
end
