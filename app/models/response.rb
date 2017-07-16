class Response < ApplicationRecord
  has_many :question_responses

  validates :first_name, presence: true
  validates :last_name, presence: true

  delegate :count, to: :question_responses, prefix: true

  def display_name
    "#{first_name} #{last_name}"
  end

  def completed?
    question_responses_count == Question.count
  end

  def scores_by_quality
    creative_quliaties_scores = []
    question_responses.group_by {|t| t.question_choice.creative_quality_id }.each do |creative_quality_id, responses|
      scores = get_creative_quality_scores(responses)
      creative_quliaties_scores << {creative_quality_id: creative_quality_id, scores: scores}
    end
    creative_quliaties_scores 

  end

  private
    def get_min_max_scores(responses)
      questions = responses.map { |x| x.question_choice.question }
      min_score = 0
      max_score = 0
      questions.each do |question|
        min_max = question.minmax_choices
        min_score += min_max[0]
        max_score += min_max[1]
      end
      [min_score, max_score]
    end

    def get_raw_score(responses)
      responses.map { |x| x.question_choice.score }.sum
    end

    def get_creative_quality_scores(responses)
      min_max = get_min_max_scores(responses)
      min_score = min_max[0] || 0
      max_score = min_max[1] || 0
      
      raw_score = get_raw_score(responses)
      
      normalized = ((min_score.abs + raw_score).to_f / (min_score.abs + max_score)) * 100
      
      {min: min_score, max: max_score, raw: raw_score, normalized: normalized.to_i}
    end

end
