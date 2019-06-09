class MembershipMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.membership_mailer.approve_confirmation.subject
  #
  def approve_confirmation(membership)
    @membership = membership

    mail to: @membership.email, subject: "Approve membership"
  end
end
