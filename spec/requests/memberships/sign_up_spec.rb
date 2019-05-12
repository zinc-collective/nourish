require 'rails_helper'

RSpec.describe "Membership sign up", type: :request do
  let!(:community) { create :community }
  describe "GET #new" do
    it "returns http success" do
      get new_community_membership_path(community.slug)
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context 'valid params' do
      let(:valid_params) { { membership: { name: Faker::Name.name, email: Faker::Internet.email } } }
      it "returns http success" do
        post community_memberships_path(community.slug), params: valid_params
        expect(response).to be_successful
      end

      it "creates new membership" do
        expect {
          post community_memberships_path(community.slug), params: valid_params
        }.to change{ Membership.count }.from(0).to(1)

        new_membership = community.memberships.find_by!(email: valid_params[:membership][:email])
        expect(new_membership.name).to eq(valid_params[:membership][:name])
        expect(new_membership.email).to eq(valid_params[:membership][:email])
      end
    end

    context 'invalid params' do
      let(:invalid_params) { { membership: { email: 'not_email' } } }
      it "did not create membership" do
        expect {
          post community_memberships_path(community.slug), params: invalid_params
        }.to_not change{ Membership.count }
      end
    end
  end

end
