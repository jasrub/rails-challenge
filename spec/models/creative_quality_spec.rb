require 'rails_helper'

describe CreativeQuality do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:color) }
  end
end
