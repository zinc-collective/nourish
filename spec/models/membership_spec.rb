require 'rails_helper'

RSpec.describe Membership, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:status_updated_at) }
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
end
