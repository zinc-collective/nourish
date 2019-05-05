require 'rails_helper'

RSpec.describe MembershipPolicy do
  let(:person) { create(:person) }
  let(:staff) { create(:person, :staff) }
  let(:community_involved) { create(:community) }
  let!(:membership_involved) { create(:membership, community: community_involved, person: person) }
  let!(:membership_not_involved) { create(:membership) }

  describe 'approval?' do
    context 'when person has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(person, nil).approval?).to be true
      end
    end

    context 'when person is nourish staff' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).approval?).to be true
      end
    end

    context 'when person is only a guest in the community' do
      let!(:membership_involved) { create(:membership, :guest, community: community_involved, person: person) }
      it 'denies access' do
        expect(MembershipPolicy.new(person, nil).approval?).to be_falsey
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

      context 'when person is nourish staff' do
        subject { described_class.new(staff, nil).resolve }
        it { is_expected.to include membership_involved }
        it { is_expected.to include membership_not_involved }
      end
    end
  end
end
