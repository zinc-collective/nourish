require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  describe 'validate uniqueness' do
    subject { Membership.new name: 'name', email: 'email@example.com', community: create(:community)  }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:community_id).case_insensitive }
  end
end
