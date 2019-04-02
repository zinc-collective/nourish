require 'rails_helper'

RSpec.describe "Membership sign up", type: :request do
  let!(:community) { create :community }
  describe "GET #new" do
    it "returns http success" do
      get "/#{community.slug}/memberships"
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context 'valid params' do
      let(:valid_params) { { name: Faker::Name.name, email: Faker::Internet.email } }
      it "returns http success" do
        post "/#{community.slug}/memberships", params: valid_params
        expect(response).to be_successful
      end

      it "creates new membership" do
        expect {
          post "/#{community.slug}/memberships", params: valid_params
        }.to change{ Membership.count }.from(0).to(1)

        new_membership = community.memberships.find_by!(email: valid_params[:email])
        expect(new_membership.name).to eq(valid_params[:name])
        expect(new_membership.email).to eq(valid_params[:email])
      end
    end

    context 'invalid params' do
      let(:invalid_params) { { email: 'not_email' } }
      it "did not create membership" do
        expect {
          post "/#{community.slug}/memberships", params: invalid_params
        }.to_not change{ Membership.count }
      end
    end
  end

end
