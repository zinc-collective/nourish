require 'rails_helper'

RSpec.describe CommunityPolicy do
  let(:policy) { described_class.new(person, community) }
  let(:community) { membership&.community }
  let(:person) { membership&.person }
  let(:membership) { nil }
  describe '#list_members?' do
    subject { policy.list_members? }

    context 'when the person is not logged in' do
      let(:person) { nil }
      it { is_expected.to eql false }
    end

    context 'when the person is not approved' do
      let(:membership) { create(:membership, :guest) }
      it { is_expected.to eql false }
    end

    context 'when the person is an approved member' do
      let(:membership) { create(:membership, :member) }
      it { is_expected.to eql true }
    end

    context 'when the person is Nourish Staff' do
      let(:person) { create(:person, :staff) }
      it { is_expected.to eql true }
    end

    context 'when the person is a community moderator' do
      let(:membership) { create(:membership, :moderator) }
      it { is_expected.to eql true }
    end
  end
end
