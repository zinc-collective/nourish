require 'rails_helper'

RSpec.describe MembershipPolicy do
  let(:person) { create(:person) }
  let(:staff) { create(:person, staff: true) }
  let(:community_involved) { create(:community) }
  let!(:membership_involved) { create(:membership, community: community_involved, person: person) }
  let!(:membership_not_involved) { create(:membership) }

  describe 'index?' do
    context 'when person has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(person, nil).index?).to be true
      end
    end

    context 'when person is only a guest in the community' do
      let!(:membership_involved) { create(:membership, :guest, community: community_involved, person: person) }
      it 'denies access' do
        expect(MembershipPolicy.new(person, nil).index?).to be_falsey
      end
    end
  end

  describe 'set_moderator' do
    context 'when person has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).set_moderator?).to be true
      end
    end

    context 'when person is only a guest in the community' do
      it 'denies access' do
        expect(MembershipPolicy.new(person, nil).set_moderator?).to be_falsey
      end
    end
  end

  describe MembershipPolicy::Scope do
    describe 'resolve' do
      subject { described_class.new(person, nil).resolve }
      context 'returns memberships that the person is involved' do
        it { is_expected.to include membership_involved }
        it { is_expected.to_not include membership_not_involved }
      end
    end
  end
end
