require "spec_helper"

RSpec.describe TaskNotifier, type: :mailer do
  describe "task_assigned" do
    let(:mail) { TaskNotifier.task_assigned('example@user.org') }

    it "renders the headers" do
      expect(mail.subject).to eq("Task assigned")
      expect(mail.to).to eq(["example@user.org"])
      expect(mail.from).to eq(["postmaster@sandboxd41599a8676d49ce94b50dc87e54a46f.mailgun.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "task_done" do
    let(:mail) { TaskNotifier.task_done('example@user.org') }

    it "renders the headers" do
      expect(mail.subject).to eq("Task done")
      expect(mail.to).to eq(["example@user.org"])
      expect(mail.from).to eq(["postmaster@sandboxd41599a8676d49ce94b50dc87e54a46f.mailgun.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "reminder" do
    let(:mail) { TaskNotifier.reminder('example@user.org') }

    it "renders the headers" do
      expect(mail.subject).to eq("Reminder")
      expect(mail.to).to eq(["example@user.org"])
      expect(mail.from).to eq(["postmaster@sandboxd41599a8676d49ce94b50dc87e54a46f.mailgun.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
