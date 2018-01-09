require 'spec_helper'

describe 'rake db:expired_assignment', type: :task do
  let(:assignment) { FactoryBot.build(:assignment) }

  describe 'general' do
    it 'preloads the Rails environment' do
      expect(task.prerequisites).to include 'environment'
    end

    it 'runs gracefully' do
      expect { task.execute }.not_to raise_error
    end
  end

  context 'when db holds expired assignment' do
    it 'sends an email notification to creator and recipient of assignment' do
      assignment.update(to_date: Date.yesterday)
      ActionMailer::Base.deliveries.clear
      task.execute
      expect(ActionMailer::Base.deliveries.map(&:to)).to eq([
        [assignment.email_of_creator],
        [assignment.email_of_recipient]
      ])
    end
    it 'resets entry.user_id to id of assignment_creator' do
      assignment.save
      expect(assignment.entry.user_id).to eq(assignment.recipient_id)
      assignment.update(to_date: Date.yesterday)
      task.execute
      expect(assignment.entry.user_id).to eq(assignment.creator_id)
    end
    it 'deletes assignment' do
      assignment.update(to_date: Date.yesterday)
      expect{ task.execute }.to change(Assignment, :count).by(-1)
    end
  end
  context 'when db does not hold an expired assignment' do
    it 'does not send an email notification' do
      assignment.save
      expect { task.execute }.not_to change(ActionMailer::Base.deliveries, :count)
    end
    it 'does not resets entry.user_id' do
      assignment.save
      task.execute
      expect(assignment.entry.user_id).to eq(assignment.recipient_id)
    end
    it 'does not deletes assignment' do
      expect{ task.execute }.to change(Assignment, :count).by(0)
    end
  end
end
