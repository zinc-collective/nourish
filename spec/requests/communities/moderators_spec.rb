require 'rails_helper'

RSpec.describe 'Communities::ModeratorsController', type: :request do
  let(:community) { create(:community) }
  let(:moderator) { create(:person) }
  let!(:moderator_membership) { create(:membership, community: community, status: 'moderator', person: moderator) }
  let(:person) { create(:person) }
  let!(:person_membership) { create(:membership, community: community, status: 'member', person: person) }
  let(:staff) { create(:person, :staff) }

  describe 'Appoint moderator' do
    context 'staff & moderator' do
      it 'redirects to community_memberships_path' do
        [staff, moderator].each do |role|
          sign_in role
          put community_moderator_path(community, person)

          expect(response).to redirect_to(community_memberships_path(community))
        end
      end
    end

    context 'non moderator' do
      it 'something' do
        sign_in person
        put community_moderator_path(community, person)

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'Dismiss moderator' do
    context 'staff & moderator' do
      it 'redirects to community_memberships_path' do
        [staff, moderator].each do |role|
          sign_in role
          delete community_moderator_path(community, person)

          expect(response).to redirect_to(community_memberships_path(community))
        end
      end
    end

    context 'non moderator' do
      it 'something' do
        sign_in person
        delete community_moderator_path(community, person)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
