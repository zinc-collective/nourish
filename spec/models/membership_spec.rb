require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it do
    is_expected.to validate_inclusion_of(:status).in_array(
      ['pending', 'member']
    )
  end

  describe 'validate uniqueness' do
    subject { create(:membership, community: create(:community)) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:community_id).case_insensitive }
  end

  describe '.build new member' do
    subject { Membership.build_new_member(membership_params) }
    let(:membership_params) do
      {
        name: Faker::App.name,
        email: Faker::Internet.email,
        person: person
      }
    end

    context 'with person' do
      let(:person) { create(:person) }
      it 'returns membership with a person attached' do
        expect(subject.name).to eq membership_params[:name]
        expect(subject.email).to eq membership_params[:email]
        expect(subject.person).to eq person
      end
    end

    context 'without person' do
      let(:person) { nil }
      it 'returns membership without person attached' do
        expect(subject.name).to eq membership_params[:name]
        expect(subject.email).to eq membership_params[:email]
        expect(subject.person).to be_nil
      end
    end
  end

  describe '#confirm' do
    let(:community) { create(:community) }
    let(:person) { create(:person) }
    let(:membership) { create(:membership, :pending, email: person.email, community: community, person: person) }
    let(:anonymous_membership) { create(:membership, :pending, community: community, person: nil) }

    context 'when person is present' do
      subject { membership.approve }

      it 'approves membership' do
        expect { subject }.to change { membership.status.to_sym }.from(:pending).to :member
      end
    end

    context 'when person is absent' do
      subject { anonymous_membership.approve }

      it 'awaits membership to be confirmed' do
        expect { subject }.to change { anonymous_membership.status.to_sym }.from(:pending).to :awaiting_confirmation
      end

      it 'request confirmation from member' do
        expect { subject }.to change { ActionMailer::Base.deliveries.count }.by 1
      end
    end
  end
end
