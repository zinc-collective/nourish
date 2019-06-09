require 'rails_helper'

RSpec.feature "Staff Member Creates Community", type: :feature do
  before do
    nourish = FactoryBot.create(:community, :nourish)
    staff_member = FactoryBot.create(:person, :staff)

    visit new_person_session_path
    find_field('person[email]').fill_in(with: staff_member.email)
    find_field('person[password]').fill_in(with:'password')
    find_button("Log in").click()

    visit communities_path
    click_link_or_button('Add Community')
  end
  scenario "Staff member creates community" do
    new_community = FactoryBot.build(:community)

    within ".community-form" do
      find_field('community[name]').fill_in(with: new_community.name)
      find_button('Create Community').click()
    end

    saved_community = Community.find_by(name: new_community.name)

    expect(saved_community).to be_present
  end

  scenario "Staff Member fails to create community" do
    within ".community-form" do
      find_button('Create Community').click()
    end

    within ".community-form .field[data-field='community[name]'].--error" do
      expect('*[name="community[name]"]').to be_present
      expect('*[data-field="community[name]"].error').to be_present
      expect(page).to have_content "can't be blank"
    end
  end
end