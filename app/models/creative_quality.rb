class CreativeQuality < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :color, optional: true
  after_create :assign_to_color

  private
    def assign_to_color
      color = Color.left_outer_joins(:creative_quality).where(creative_qualities: {id: nil}).first
      if color
        self.color_id = color.id
        self.save
      end
    end
end
