class Color < ApplicationRecord
  validates :name, presence: true
  has_one :creative_quality
end
