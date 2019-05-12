require 'rails_helper'

RSpec.describe ModeratorPolicy do
  let(:community) { create(:community) }
  let(:moderator) { create(:person) }
  let!(:moderator_membership) { create(:membership, community: community, status: 'moderator', person: moderator) }
  let(:person) { create(:person) }
  let!(:person_membership) { create(:membership, community: community, status: 'member', person: person) }
  let(:staff) { create(:person, :staff) }

  describe '#update?' do
    context 'staff' do
      subject { ModeratorPolicy.new(staff, community).update? }
      it { is_expected.to be true }
    end

    context 'moderator' do
      subject { ModeratorPolicy.new(moderator, community).update? }
      it { is_expected.to be true }
    end

    context 'non moderator' do
      subject { ModeratorPolicy.new(person, community).update? }
      it { is_expected.to be_falsey }
    end
  end
end
