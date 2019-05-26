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

  describe '#join?' do
    subject { policy.join? }
    context 'when the person is not logged in' do
      let(:person) { nil }
      it { is_expected.to eql true }
    end

    context 'when the person is logged in, but has no membership' do
      let(:person) { create(:person) }
      it { is_expected.to eql true }
    end

    context 'when the person is not approved' do
      let(:membership) { create(:membership, :guest) }
      it { is_expected.to eql false }
    end

    context 'when the person is an approved member' do
      let(:membership) { create(:membership, :member) }
      it { is_expected.to eql false }
    end

    context 'when the person is Nourish Staff' do
      let(:person) { create(:person, :staff) }
      it { is_expected.to eql true }

      context 'and already a member of the community' do
        let(:membership) { create(:membership, :guest, person: person) }
        it { is_expected.to eql false }
      end
    end

    context 'when the person is a community moderator' do
      let(:membership) { create(:membership, :moderator) }
      it { is_expected.to eql false }
    end
  end

  describe '#edit?' do
    subject { policy.edit? }

    context 'when the person is not logged in' do
      let(:person) { nil }
      it { is_expected.to be_falsey }
    end

    context 'when person is a nourish staff' do
      let(:person) { create(:person, :staff) }
      it { is_expected.to eql true }
    end

    context 'when person is a moderator of the community' do
      let(:membership) { create(:membership, :moderator) }
      it { is_expected.to be true }
    end

    context 'when person is not a moderator of the community' do
      let(:person) { create(:person) }
      let(:membership) { create(:membership, :member) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#update?' do
    subject { policy.update? }

    context 'when the person is not logged in' do
      let(:person) { nil }
      it { is_expected.to be_falsey }
    end

    context 'when person is a nourish staff' do
      let(:person) { create(:person, :staff) }
      it { is_expected.to eql true }
    end

    context 'when person is a moderator of the community' do
      let(:membership) { create(:membership, :moderator) }
      it { is_expected.to be true }
    end

    context 'when person is not a moderator of the community' do
      let(:person) { create(:person) }
      let(:membership) { create(:membership, :member) }
      it { is_expected.to be_falsey }
    end
  end
end
