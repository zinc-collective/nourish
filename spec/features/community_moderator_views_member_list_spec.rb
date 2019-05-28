require 'rails_helper'

RSpec.feature "Community Moderator Views Member List", :type => :feature do
  scenario "Moderator reviews Members" do
    nourish = FactoryBot.create(:community, :nourish)
    community = FactoryBot.create(:community)
    approved_membership = FactoryBot.create(:membership, :member, community: community)
    approved_member = approved_membership.person
    pending_membership = FactoryBot.create(:membership, :pending, community: community)
    pending_member = pending_membership.person
    moderator_membership = FactoryBot.create(:membership, :moderator, community: community)
    moderator = moderator_membership.person

    visit new_person_session_path
    find_field('person[email]').fill_in(with: moderator.email)
    find_field('person[password]').fill_in(with:'password')
    find_button("Log in").click()

    visit community_memberships_path(community)

    # Ensure each membership has all the expected data in the expected containers
    [pending_membership, approved_membership, moderator_membership].each do |membership|
      within ".membership.--#{membership.status}[data-id='#{membership.id}']" do
        within('.name') { expect(page).to have_text(membership.name) }
        within('.email') { expect(page).to have_text(membership.email) }
        within(".status.--#{membership.status}") { expect(page).to have_text(membership.status) }
        within('.onboarding-question') { expect(page).to have_text(community.onboarding_question) }
        within('.onboarding-question-response') do
          expect(page).to have_text(membership.onboarding_question_response)
        end
      end
    end


    # Confirm pending members only have their relevant buttons
    within ".membership.--pending[data-id='#{pending_membership.id}']" do
      expect(page).to have_selector('.approve-member')
      expect(page).not_to have_selector('.promote-to-moderator')
      expect(page).not_to have_selector('.demote-from-moderator')
    end

    # Confirm moderators only have their relevant buttons
    within ".membership.--moderator[data-id='#{moderator_membership.id}']" do
      expect(page).not_to have_selector('.approve-member')
      expect(page).not_to have_selector('.promote-to-moderator')
      expect(page).to have_selector('.demote-from-moderator')
    end

    # Confirm members only have their relevant buttons
    within ".membership.--member[data-id='#{approved_membership.id}']" do
      expect(page).not_to have_selector('.approve-member')
      expect(page).to have_selector('.promote-to-moderator')
      expect(page).not_to have_selector('.demote-from-moderator')
    end

  end
end