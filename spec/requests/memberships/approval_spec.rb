require 'rails_helper'

RSpec.describe 'Membership approval', type: :request do
  describe 'approval' do
    let(:community) { create(:community) }

    let(:not_moderator) { create(:person) }
    let!(:membership_to_be_approve) { create(:membership, :pending, community: community, person: not_moderator) }

    let(:moderator) { create(:person) }
    let!(:moderator_membership) { create(:membership, :moderator, community: community, person: moderator) }

    let(:staff) { create(:person, staff: true) }
    context 'staff' do
      it 'returns http success' do
        sign_in staff

        post membership_approve_path(membership_to_be_approve)

        expect(membership_to_be_approve.reload.status).to eq 'awaiting_confirmation'
        expect(response).to redirect_to(community_memberships_path(membership_to_be_approve.community.slug))
      end
    end

    context 'moderator' do
      it 'returns http success' do
        sign_in moderator

        post membership_approve_path(membership_to_be_approve)

        expect(membership_to_be_approve.reload.status).to eq 'awaiting_confirmation'
        expect(response).to redirect_to(community_memberships_path(membership_to_be_approve.community.slug))
      end
    end

    context 'not moderator' do
      it 'redirects to root' do
        sign_in not_moderator

        post membership_approve_path(membership_to_be_approve)

        expect(membership_to_be_approve.reload.status).to eq 'pending'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
