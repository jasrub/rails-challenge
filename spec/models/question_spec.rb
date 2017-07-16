require 'rails_helper'

describe Question do
  context 'associations' do
    it { is_expected.to have_many(:choices) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  describe "#minmax_choices" do
    context "with no choices" do
      it "returns [nil, nil]" do
        question = Question.new
        expect(question.minmax_choices).to eq [nil, nil]
      end
    end

    context "with one choice" do
      it "returns min = max = choice score" do
        question = Question.create(  {
        title: "question with one choice",
        choices_attributes: [ { text: 'Energizing', creative_quality_id: 1, score: 1 }]
        })
        expect(question.minmax_choices).to eq [1, 1]
      end
    end

    context "with more than one choice" do
      it "returns the min and max scores of choices" do
        question = Question.create(  {
        title: "question with more than one choice",
        choices_attributes: [ 
          {text: 'Energizing', creative_quality_id: 1, score: 1 },
          {text: 'Energizing', creative_quality_id: 1, score: 1 },
          {text: 'Energizing', creative_quality_id: 1, score: -3 },
          {text: 'Energizing', creative_quality_id: 1, score: 0 },
          {text: 'Energizing', creative_quality_id: 1, score: 7 },
       ]
        })
        expect(question.minmax_choices).to eq [-3, 7]
      end
    end
  end
end
