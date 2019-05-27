# Preview all emails at http://localhost:3000/rails/mailers/membership_mailer
class MembershipMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/membership_mailer/approve_confirmation
  def approve_confirmation
    MembershipMailerMailer.approve_confirmation
  end

end
