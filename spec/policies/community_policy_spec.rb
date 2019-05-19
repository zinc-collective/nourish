require 'rails_helper'

RSpec.describe CommunityPolicy do
  let(:staff) { create(:person, :staff) }
  let(:not_staff) { create(:person) }

  describe 'show?' do
    context 'when person is a nourish staff' do
      it 'allows access' do
        expect(CommunityPolicy.new(staff, nil).show?).to be true
      end
    end

    context 'when person is not a nourish staff' do
      it 'denies access' do
        expect(CommunityPolicy.new(not_staff, nil).show?).to be_falsey
      end
    end
  end
end
