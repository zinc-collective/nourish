# Preview all emails at http://localhost:3000/rails/mailers/membership_mailer
class MembershipMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/membership_mailer/approve_confirmation
  def approve_confirmation
    community = Community.create(name: 'Nourish')
    membership = Membership.create(name: 'Test Name 1', email: 'member@example.com', community: community)
    MembershipMailer.approve_confirmation(membership)
  end

end
