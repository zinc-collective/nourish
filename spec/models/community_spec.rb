require 'rails_helper'

RSpec.describe Community, type: :model do
  it { is_expected.to validate_uniqueness_of(:slug) }
end
