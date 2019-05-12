require 'rails_helper'

RSpec.describe 'Membership index', type: :request do
  describe 'index' do
    let(:person) { create(:person) }
    let(:community) { create(:community) }
    context 'approved member' do
      let!(:membership) { create(:membership, community: community, person: person) }
      before { sign_in person }
      it 'returns http success' do
        get community_memberships_path(community)
        expect(response).to be_successful
      end
    end

    context 'member not involved in community' do
      before { sign_in person }
      it 'returns http success' do
        get community_memberships_path(community)
        expect(response).to be_successful
      end
    end

    context 'not logged in' do
      it 'redirect to user sign_in page' do
        get community_memberships_path(community)
        expect(response).to redirect_to(new_person_session_path)
      end
    end
  end
end
