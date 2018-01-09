require 'spec_helper'

describe 'rake db:reminder_assignment', type: :task do
  let(:assignment) { FactoryBot.build(:assignment) }

  describe 'general' do
    it 'preloads the Rails environment' do
      expect(task.prerequisites).to include 'environment'
    end

    it 'runs gracefully' do
      expect { task.execute }.not_to raise_error
    end
  end

  context 'when db holds remindable assignments ' do
    it 'sends an email notification to recipient of assignment' do
      assignment.save
      Timecop.freeze(Date.today + 2.month + 2.days) do
        task.execute
        expect { task.execute }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
  context 'when db does not hold an remindable assignment' do
    it 'does not send an email notification' do
      assignment.save
      expect { task.execute }.to change(ActionMailer::Base.deliveries, :count).by(0)
    end
  end
end
