class Question < ApplicationRecord
  has_many :choices, class_name: 'QuestionChoice', inverse_of: :question

  validates :title, presence: true

  accepts_nested_attributes_for(:choices)

  def minmax_choices
    # return [nil, nil] if question has no associated choices
    self.choices.map { |choice| choice.score}.minmax
  end
end
