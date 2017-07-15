class AddColorToCreativeQualities < ActiveRecord::Migration[5.0]
  def change
    add_reference :creative_qualities, :color, foreign_key: true
  end
end
