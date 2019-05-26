require 'rails_helper'

RSpec.feature "Community Moderator Views Member List", :type => :feature do
  scenario "Community Member reviews Members" do
    nourish = FactoryBot.create(:community, :nourish)
    community = FactoryBot.create(:community)
    pending_membership = FactoryBot.create(:membership, :pending, community: community, onboarding_question_response: "A response!")
    pending_member = pending_membership.person
    moderator_membership = FactoryBot.create(:membership, :moderator, community: community)
    moderator = moderator_membership.person

    visit new_person_session_path
    find_field('person[email]').fill_in(with: moderator.email)
    find_field('person[password]').fill_in(with:'password')
    find_button("Log in").click()
    visit community_memberships_path(community)

    within ".membership--pending[data-test-id='#{pending_membership.id}']" do
      aggregate_failures do
        expect(page).to have_text(pending_membership.name)
        expect(page).to have_text(pending_membership.email)
        expect(page).to have_text('pending')
        expect(page).to have_text(pending_membership.onboarding_question_response)
      end
    end
  end
end