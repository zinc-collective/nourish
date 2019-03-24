require 'rails_helper'

RSpec.describe Community, type: :model do
  describe 'validate presence' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
  end

  describe 'validate uniqueness' do
    subject { Community.new name: 'community_name', slug: 'community_name' }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end
end
