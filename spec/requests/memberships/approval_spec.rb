require 'rails_helper'

RSpec.describe 'Membership approval', type: :request do
  describe 'approval' do
    let(:community) { create(:community) }

    let(:not_moderator) { create(:person) }
    let!(:pending_membership) { create(:membership, :pending, email: not_moderator.email, community: community, person: not_moderator) }
    let!(:pending_membership_with_different_email) { create(:membership, :pending, community: community, person: not_moderator) }
    let!(:anonymous_membership_to_be_approve) { create(:membership, :pending, community: community, person: nil) }

    let(:moderator) { create(:person) }
    let!(:moderator_membership) { create(:membership, :moderator, community: community, person: moderator) }

    let(:staff) { create(:person, staff: true) }

    shared_examples 'membership belongs to a person' do
      it 'approves membership' do
        sign_in person

        post membership_approve_path(pending_membership)

        expect(pending_membership.reload.status).to eq 'member'
        expect(response).to redirect_to(community_memberships_path(pending_membership.community.slug))
      end
    end

    shared_examples 'membership belongs to a person with a different email' do
      it 'update memberships to awaiting confirmation' do
        sign_in person

        post membership_approve_path(pending_membership_with_different_email)

        expect(pending_membership_with_different_email.reload.status).to eq 'awaiting_confirmation'
        expect(response).to redirect_to(community_memberships_path(pending_membership_with_different_email.community.slug))
      end
    end

    shared_examples 'membership does not belong to a person' do
      it 'update memberships to awaiting confirmation' do
        sign_in person

        post membership_approve_path(anonymous_membership_to_be_approve)

        expect(anonymous_membership_to_be_approve.reload.status).to eq 'awaiting_confirmation'
        expect(response).to redirect_to(community_memberships_path(pending_membership.community.slug))
      end
    end

    context 'staff' do
      let(:person) { staff }
      include_examples 'membership belongs to a person'
      include_examples 'membership does not belong to a person'
      include_examples 'membership belongs to a person with a different email'
    end

    context 'moderator' do
      let(:person) { moderator }
      include_examples 'membership belongs to a person'
      include_examples 'membership does not belong to a person'
      include_examples 'membership belongs to a person with a different email'
    end

    context 'not moderator' do
      it 'redirects to root' do
        sign_in not_moderator

        post membership_approve_path(pending_membership)

        expect(pending_membership.reload.status).to eq 'pending'
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
