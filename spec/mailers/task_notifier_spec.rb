require 'spec_helper'

RSpec.describe TaskNotifier, type: :mailer do
  let(:task) { create(:task) }
  let(:default_sender) { 'postmaster@sandboxd41599a8676d49ce94b50dc87e54a46f.mailgun.org' }
  describe 'task_assigned' do
    let(:mail) { TaskNotifier.task_assigned(task) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Zuweisung eines Eintrags')
      expect(mail.to).to eq([task.email_of_assigned_user])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['dir wurde der Eintrag', 'zugewiesen'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end

  describe 'task_done' do
    let(:mail) { TaskNotifier.task_done(task) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Eine von Dir deligierte Aufgabe wurde erledigt')
      expect(mail.to).to eq([task.email_of_task_creator])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['die von dir deligierte Aufgabe', 'wurde soeben erledigt!'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end

  describe 'task_expired' do
    let(:mail) { TaskNotifier.task_expired(task) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Eine von Dir deligierte Aufgabe wurde nicht erledigt')
      expect(mail.to).to eq([task.email_of_task_creator])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['die von dir deligierte Aufgabe', 'wurde nicht erledigt!'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end
end
