require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:status_updated_at) }
  it do
    is_expected.to validate_inclusion_of(:status).in_array(
      ['guest', 'member']
    )
  end

  describe 'validate uniqueness' do
    subject { create(:membership, community: create(:community)) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:community_id).case_insensitive }
  end
end
