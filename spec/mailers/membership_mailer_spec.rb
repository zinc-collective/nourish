require "rails_helper"

RSpec.describe MembershipMailer, type: :mailer do
  let(:membership) { create(:membership, :pending, email: 'to@example.org') }
  describe "approve_confirmation" do
    let(:mail) { MembershipMailer.approve_confirmation(membership) }

    it "renders the headers" do
      expect(mail.subject).to eq("Approve membership")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
