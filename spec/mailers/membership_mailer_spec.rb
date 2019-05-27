require "rails_helper"

RSpec.describe MembershipMailer, type: :mailer do
  describe "approve_confirmation" do
    let(:mail) { MembershipMailer.approve_confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Approve confirmation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
