require 'rails_helper'

RSpec.describe MembershipPolicy do
  let(:pending) { create(:person) }
  let(:member) { create(:person) }
  let(:staff) { create(:person, :staff) }
  let(:moderator) { create(:person) }
  let(:community) { create(:community) }
  let!(:pending_membership) { create(:membership, :pending, community: community, person: pending) }
  let!(:approved_membership) { create(:membership, :member, community: community, person: member) }
  let!(:moderator_membership) { create(:membership, :moderator, community: community, person: moderator) }
  let!(:membership_not_involved) { create(:membership) }
  let(:policy) { described_class.new(person, membership) }
  let(:membership) { nil }
  let(:person) { nil }
  describe '#index?' do
    let(:membership) { community.memberships }
    subject { policy.index? }
    context 'when the person is nil' do
      let(:person) { nil }
      it { is_expected.to eql false }
    end
    context 'when the person is not a member of the community' do
      let(:person) { membership_not_involved.person }
      it { is_expected.to eql false }
    end

    context "when the person's community membership is pending" do
      let(:person) { pending_membership.person }
      it { is_expected.to eql false }
    end

    context 'when the person is a member of the community' do
      let(:person) { approved_membership.person }
      it { is_expected.to eql true }
    end
    context 'when the person is a moderator of the community' do
      let(:person) { moderator_membership.person }
      it { is_expected.to eql true }
    end
  end

  describe 'approval?' do
    context 'when moderator has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(moderator, moderator_membership).approval?).to be true
      end
    end

    context 'when person is nourish staff' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).approval?).to be true
      end
    end

    context "when the person's community membership is pending" do
      let!(:approved_membership) { create(:membership, :pending, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, approved_membership).approval?).to be_falsey
      end
    end
  end

  describe 'show_email?' do
    context 'when moderator has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(moderator, moderator_membership).show_email?).to be true
      end
    end

    context 'when person is nourish staff' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).show_email?).to be true
      end
    end

    context 'when person is only a member in the community' do
      let!(:approved_membership) { create(:membership, :member, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, approved_membership).show_email?).to be_falsey
      end
    end

    context "when the person's community membership is pending" do
      let!(:approved_membership) { create(:membership, :pending, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, approved_membership).show_email?).to be_falsey
      end
    end
  end

  describe MembershipPolicy::Scope do
    describe 'resolve' do
      subject { described_class.new(member, nil).resolve }
      context 'returns memberships that the person is involved' do
        it { is_expected.to include approved_membership }
        it { is_expected.to_not include membership_not_involved }
      end

      context 'when person is nourish staff' do
        subject { described_class.new(staff, nil).resolve }
        it { is_expected.to include approved_membership }
        it { is_expected.to include membership_not_involved }
      end
    end
  end
end
