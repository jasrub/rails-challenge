require 'rails_helper'

describe Response do
  context 'associations' do
    it { is_expected.to have_many(:question_responses) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe '#display_name' do
    let(:response) { Response.new(first_name: 'Tal', last_name: 'Safran') }

    it 'concatenates the first and last name' do
      expect(response.display_name).to eql('Tal Safran')
    end
  end

  describe '#completed?' do
    let(:response) { Response.new }

    before do
      allow(Question).to receive(:count).and_return(3)
      allow(response).to receive_message_chain(:question_responses, :count)
        .and_return(response_count)
    end

    context 'when no responses exist' do
      let(:response_count) { 0 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when some responses exist' do
      let(:response_count) { 1 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when responses exist for all questions' do
      let(:response_count) { 3 }
      it 'is true' do
        expect(response.completed?).to be(true)
      end
    end
  end

  describe '#scores_by_quality' do
    context 'with no question_responses' do
      it 'returns an empty array' do
        response = Response.new
        expect(response.scores_by_quality).to eq []
      end
    end
    
    context 'with some reponses one quality' do
      it 'returns the correct scores in an array with one object' do
        @response = Response.create!(first_name: 'test', last_name: 'test')
        question1 = Question.create!(title: 'test_questio1')
        question2 = Question.create!(title: 'test_questio2')
        quality = CreativeQuality.create!(name: 'quality_test', description: 'test quality')
        choice1 = QuestionChoice.create!({ text: 'question 1 choice 1', creative_quality_id: quality.id, score: 2, question_id: question1.id })
        choice2 = QuestionChoice.create!({ text: 'question 1 choice 2', creative_quality_id: quality.id, score: -2, question_id: question1.id })
        choice3 = QuestionChoice.create!({ text: 'question 2 choice 1', creative_quality_id: quality.id, score: 4, question_id: question2.id })
        @response.question_responses.create!({question_choice_id: choice1.id})
        @response.question_responses.create!({question_choice_id: choice3.id})
        
        scores_array = @response.scores_by_quality()
        expect(scores_array).not_to be_empty
        expect(scores_array.length).to eq 1
        expect(scores_array[0][:scores][:min]).to eq 2
        expect(scores_array[0][:scores][:max]).to eq 6
        expect(scores_array[0][:scores][:raw]).to eq 6
        expect(scores_array[0][:scores][:normalized]).to eq 100
      end
    end

    context 'with some reponses two qualities' do
      it 'returns the correct scores in an array with two objects' do
        @response = Response.create!(first_name: 'test', last_name: 'test')
        question1 = Question.create!(title: 'test_questio1')
        question2 = Question.create!(title: 'test_questio2')
        question3 = Question.create!(title: 'test_questio3')
        quality1 = CreativeQuality.create!(name: 'quality_test', description: 'test quality')
        quality2 = CreativeQuality.create!(name: 'quality_test', description: 'test quality')
        
        choice1 = QuestionChoice.create!({ text: 'question 1 choice 1', creative_quality_id: quality1.id, score: 2, question_id: question1.id })
        choice2 = QuestionChoice.create!({ text: 'question 1 choice 2', creative_quality_id: quality1.id, score: 4, question_id: question1.id })

        choice3 = QuestionChoice.create!({ text: 'question 2 choice 1', creative_quality_id: quality1.id, score: -2, question_id: question2.id })

        choice4 = QuestionChoice.create!({ text: 'question 3 choice 1', creative_quality_id: quality2.id, score: -10, question_id: question3.id })
        choice5 = QuestionChoice.create!({ text: 'question 3 choice 2', creative_quality_id: quality2.id, score: 5, question_id: question3.id })
        choice6 = QuestionChoice.create!({ text: 'question 3 choice 3', creative_quality_id: quality2.id, score: 7, question_id: question3.id })
        
        @response.question_responses.create!({question_choice_id: choice1.id})
        @response.question_responses.create!({question_choice_id: choice3.id})
        @response.question_responses.create!({question_choice_id: choice5.id})
        
        scores_array = @response.scores_by_quality()
        expect(scores_array).not_to be_empty
        expect(scores_array.length).to eq 2

        expect(scores_array[0][:scores][:min]).to eq 0
        expect(scores_array[0][:scores][:max]).to eq 2
        expect(scores_array[0][:scores][:raw]).to eq 0
        expect(scores_array[0][:scores][:normalized]).to eq 0

        expect(scores_array[1][:scores][:min]).to eq -10
        expect(scores_array[1][:scores][:max]).to eq 7
        expect(scores_array[1][:scores][:raw]).to eq 5
        expect(scores_array[1][:scores][:normalized]).to eq 88
      end
    end
  end
end
