require 'rails_helper'

RSpec.describe QuizQuestion, type: :model do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user:) }
  let(:question) { create(:question, quizzes: [quiz]) }

  describe 'バリデーションに関するテスト' do
    context '有効な場合' do
      it '質問とクイズがあれば有効であること' do
        quiz_question = QuizQuestion.new(quiz:, question:)
        expect(quiz_question).to be_valid
      end
    end

    context '無効な場合' do
      it 'クイズがない場合は無効であること' do
        quiz_question = QuizQuestion.new(quiz: nil, question:)
        expect(quiz_question).to be_invalid
        expect(quiz_question.errors[:quiz]).to include("を入力してください")
      end

      it '質問がない場合は無効であること' do
        quiz_question = QuizQuestion.new(quiz:, question: nil)
        expect(quiz_question).to be_invalid
        expect(quiz_question.errors[:question]).to include("を入力してください")
      end
    end
  end

  describe '関連づけに関するテスト' do
    it 'QuizQuestionは1つのQuizに属すること' do
      assoc = described_class.reflect_on_association(:quiz)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'QuizQuestionは1つのQuestionに属すること' do
      assoc = described_class.reflect_on_association(:question)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
