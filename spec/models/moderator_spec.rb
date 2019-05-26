require 'rails_helper'

RSpec.describe Moderator, type: :model do
  let(:community) { create(:community) }
  let(:person) { create(:person) }
  describe '.appoint!' do
    let!(:membership) { create(:membership, :member, person: person, community: community) }
    it 'assigns moderator status to a person' do
      Moderator.appoint!(person: person, community: community)

      expect(person.memberships.find_by(community: community).status).to eq 'moderator'
    end
  end

  describe '.dismiss!' do
    let!(:membership) { create(:membership, :moderator, person: person, community: community) }
    it 'removes moderator status to a person' do
      Moderator.dismiss!(person: person, community: community)

      expect(person.memberships.find_by(community: community).status).to eq 'member'
    end
  end

  describe '.of?' do
    context 'moderator' do
      let!(:membership) { create(:membership, :moderator, person: person, community: community) }
      subject { Moderator.of?(person: person, community: community) }
      it { is_expected.to be true }
    end

    context 'not moderator' do
      let!(:membership) { create(:membership, :pending, person: person, community: community) }
      subject { Moderator.of?(person: person, community: community) }
      it { is_expected.to be_falsey }
    end
  end
end
