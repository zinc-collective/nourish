require 'rails_helper'
require 'support/policy_exerciser'
RSpec.describe MembershipPolicy do
  let(:staff) { create(:person, :staff) }
  let(:community) {  create(:community) }
  let(:guest_membership) { create(:membership, person: nil)}
  let(:pending_membership) { create(:membership, :pending, community: community) }
  let(:pending_member) { pending_membership.person }

  let(:approved_membership) { create(:membership, :member, community: community) }
  let(:member) { approved_membership.person }

  let(:moderator_membership) { create(:membership, :moderator, community: community) }
  let(:moderator) { moderator_membership.person }

  let(:other_community_membership) { create(:membership) }
  let(:other_community_member) { other_community_membership.person }

  let(:policy) { described_class.new(person, membership) }
  let(:membership) { nil }
  let(:person) { nil }

  describe "#index?" do
    subject { PolicyExerciser.new(described_class, :index?) }
    it { is_expected.not_to be_allowed(person: nil, record: community.memberships) }
    it { is_expected.not_to be_allowed(person: other_community_membership.person, record: community.memberships) }
    it { is_expected.not_to be_allowed(person: pending_membership.person, record: community.memberships) }
    it { is_expected.to be_allowed(person: approved_membership.person, record: community.memberships) }
    it { is_expected.to be_allowed(person: moderator, record: community.memberships) }
  end

  describe "#promote_moderator?" do
    subject { PolicyExerciser.new(described_class, :promote_moderator?) }
    it { is_expected.not_to be_allowed(person: nil, record: approved_membership) }
    it { is_expected.not_to be_allowed(person: member, record: approved_membership) }
    it { is_expected.not_to be_allowed(person: pending_member, record: approved_membership) }
    it { is_expected.not_to be_allowed(person: other_community_member, record: approved_membership) }
    it { is_expected.to be_allowed(person: moderator, record: approved_membership) }
    it { is_expected.to be_allowed(person: staff, record: approved_membership) }

    context "when a membership doesn't have a person attached" do
      it { is_expected.not_to be_allowed(person: moderator, record: guest_membership) }
    end
  end

  describe "#demote_moderator?" do
    subject { PolicyExerciser.new(described_class, :demote_moderator?) }
    it { is_expected.not_to be_allowed(person: nil, record: moderator_membership) }
    it { is_expected.not_to be_allowed(person: member, record: moderator_membership) }
    it { is_expected.not_to be_allowed(person: pending_member, record: moderator_membership) }
    it { is_expected.not_to be_allowed(person: other_community_member, record: moderator_membership) }
    it { is_expected.to be_allowed(person: moderator, record: moderator_membership) }
    it { is_expected.to be_allowed(person: staff, record: moderator_membership) }

    context "when the membership is not for a moderator" do
      it { is_expected.not_to be_allowed(person: moderator, record: approved_membership) }
      it { is_expected.not_to be_allowed(person: staff, record: approved_membership) }
    end
  end

  describe "#approve_member?" do
    subject { PolicyExerciser.new(described_class, :approve_member?) }
    it { is_expected.not_to be_allowed(person: nil, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: pending_member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: other_community_member, record: pending_membership) }
    it { is_expected.to be_allowed(person: moderator, record: pending_membership) }
    it { is_expected.to be_allowed(person: staff, record: pending_membership) }
  end

  describe "#show_onboarding_response?" do
    subject { PolicyExerciser.new(described_class, :show_onboarding_question_response?) }
    it { is_expected.not_to be_allowed(person: nil, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: pending_member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: other_community_member, record: pending_membership) }
    it { is_expected.to be_allowed(person: moderator, record: pending_membership) }
    it { is_expected.to be_allowed(person: staff, record: pending_membership) }
  end

  describe 'show_email?' do
    subject { PolicyExerciser.new(described_class, :show_email?) }
    it { is_expected.not_to be_allowed(person: nil, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: pending_member, record: pending_membership) }
    it { is_expected.not_to be_allowed(person: other_community_member, record: pending_membership) }
    it { is_expected.to be_allowed(person: moderator, record: pending_membership) }
    it { is_expected.to be_allowed(person: staff, record: pending_membership) }
  end

  describe MembershipPolicy::Scope do
    before { [approved_membership, other_community_membership] }
    describe 'resolve' do
      subject { described_class.new(member, nil).resolve }
      context 'returns memberships that the person is involved' do
        it { is_expected.to include approved_membership }
        it { is_expected.to_not include other_community_membership }
      end

      context 'when person is nourish staff' do
        subject { described_class.new(staff, nil).resolve }
        it { is_expected.to include approved_membership }
        it { is_expected.to include other_community_membership }
      end
    end
  end
end
