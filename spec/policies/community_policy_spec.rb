require 'rails_helper'

RSpec.describe CommunityPolicy do
  let(:staff) { create(:person, :staff) }
  let(:community) { create(:community) }

  let(:non_member) { create(:person) }

  let(:approved_membership) { create(:membership, community: community) }
  let(:member) { approved_membership.person }

  let(:pending_membership) { create(:membership, :pending, community: community) }
  let(:pending_member) { pending_membership.person}

  let(:moderator_membership) { create(:membership, :moderator, community: community) }
  let(:moderator) { moderator_membership.person }

  describe "#create?" do
    subject { PolicyExerciser.new(described_class, :create?) }
    it { is_expected.not_to be_allowed(person: nil, record: nil) }
    it { is_expected.not_to be_allowed(person: member, record: nil) }
    it { is_expected.not_to be_allowed(person: moderator, record: nil) }
    it { is_expected.not_to be_allowed(person: pending_member, record: nil) }

    it { is_expected.to be_allowed(person: staff, record: nil) }
  end

  describe "#new?" do
    subject { PolicyExerciser.new(described_class, :new?) }
    it { is_expected.not_to be_allowed(person: nil, record: nil) }
    it { is_expected.not_to be_allowed(person: member, record: nil) }
    it { is_expected.not_to be_allowed(person: moderator, record: nil) }
    it { is_expected.not_to be_allowed(person: pending_member, record: nil) }

    it { is_expected.to be_allowed(person: staff, record: nil) }
  end

  describe '#list_members?' do
    subject { PolicyExerciser.new(described_class, :list_members?) }
    it { is_expected.not_to be_allowed(person: nil, record: community) }
    it { is_expected.not_to be_allowed(person: pending_member, record: community) }
    it { is_expected.to be_allowed(person: member, record: community) }
    it { is_expected.to be_allowed(person: staff, record: community) }
    it { is_expected.to be_allowed(person: moderator, record: community) }
  end

  describe '#join?' do
    subject { PolicyExerciser.new(described_class, :join?) }
    it { is_expected.to be_allowed(person: nil, record: community) }
    it { is_expected.to be_allowed(person: non_member, record: community) }
    it { is_expected.to be_allowed(person: staff, record: community) }

    it { is_expected.not_to be_allowed(person: member, record: community) }
    it { is_expected.not_to be_allowed(person: pending_member, record: community) }
    it { is_expected.not_to be_allowed(person: moderator, record: community) }


    context "When the staff member already has a membership in the community" do
      before do
        create(:membership, :pending, person: staff, community: community)
      end
      it { is_expected.not_to be_allowed(person: staff, record: community) }
    end
  end

  describe '#edit?' do
    subject { PolicyExerciser.new(described_class, :edit?) }
    it { is_expected.to be_allowed(person: staff, record: community) }
    it { is_expected.to be_allowed(person: moderator, record: community) }

    it { is_expected.not_to be_allowed(person: nil, record: community) }
    it { is_expected.not_to be_allowed(person: non_member, record: community) }
    it { is_expected.not_to be_allowed(person: member, record: community) }
    it { is_expected.not_to be_allowed(person: pending_member, record: community) }
  end

  describe '#update?' do
    subject { PolicyExerciser.new(described_class, :update?) }
    it { is_expected.to be_allowed(person: staff, record: community) }
    it { is_expected.to be_allowed(person: moderator, record: community) }

    it { is_expected.not_to be_allowed(person: nil, record: community) }
    it { is_expected.not_to be_allowed(person: non_member, record: community) }
    it { is_expected.not_to be_allowed(person: member, record: community) }
    it { is_expected.not_to be_allowed(person: pending_member, record: community) }
  end
end
