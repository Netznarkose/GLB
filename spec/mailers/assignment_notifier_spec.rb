require 'spec_helper'

RSpec.describe AssignmentNotifier, type: :mailer do
  let(:assignment) { create(:assignment) }
  let(:default_sender) { 'postmaster@sandboxd41599a8676d49ce94b50dc87e54a46f.mailgun.org' }
  describe 'create' do
    let(:mail) { AssignmentNotifier.create(assignment) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Zuweisung eines Eintrags')
      expect(mail.to).to eq([assignment.email_of_recipient])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['dir wurde der Eintrag', 'zugewiesen'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end

  describe 'done' do
    let(:mail) { AssignmentNotifier.done(assignment) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Eine von Dir deligierte Aufgabe wurde erledigt')
      expect(mail.to).to eq([assignment.email_of_creator])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['die von dir deligierte Aufgabe', 'wurde soeben erledigt!'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end

  describe 'expired' do
    let(:mail) { AssignmentNotifier.expired(assignment) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Eine von Dir deligierte Aufgabe wurde nicht erledigt')
      expect(mail.to).to eq([assignment.email_of_creator])
      expect(mail.from).to eq([default_sender])
    end

    it 'renders the body' do
      ['die von dir deligierte Aufgabe', 'wurde nicht erledigt!'].map do |string|
        expect(mail.body.encoded).to include(string)
      end
    end
  end
end
