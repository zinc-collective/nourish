require 'rails_helper'

RSpec.describe 'Membership confirm', type: :request do
  describe 'confirm' do
    let(:community) { create(:community) }

    let(:person) { create(:person) }
    let!(:membership_to_be_confirmed) { create(:membership, :awaiting_confirmation, community: community, person: nil) }

    describe '#confirmation_page' do
      context 'not logged in' do
        it 'redirects to sign in page' do
          get membership_confirmation_page_path(membership_to_be_confirmed)
          expect(response).to redirect_to(new_person_session_path)
        end
      end

      context 'logged in' do
        it 'success' do
          sign_in person
          get membership_confirmation_page_path(membership_to_be_confirmed)
          expect(response).to be_successful
        end
      end
    end

    describe '#confirm' do
      context 'not logged in' do
        it 'redirect to user sign_in page' do
          post membership_confirm_path(membership_to_be_confirmed)
          expect(response).to redirect_to(new_person_session_path)
        end
      end

      context 'logged in' do
        it 'confirm memberships and connect with person' do
          sign_in person
          post membership_confirm_path(membership_to_be_confirmed)
          membership_to_be_confirmed.reload

          expect(response).to redirect_to(community_memberships_path(membership_to_be_confirmed.community.slug))
          expect(membership_to_be_confirmed.person).to eq person
          expect(membership_to_be_confirmed.member?).to be true
        end
      end
    end
  end
end
