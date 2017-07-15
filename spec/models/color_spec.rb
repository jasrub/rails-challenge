require 'rails_helper'

describe Color do
  context 'associations' do
    it { is_expected.to have_one(:creative_quality) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
