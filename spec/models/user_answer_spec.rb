require 'rails_helper'

RSpec.describe UserAnswer, type: :model do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz) }
  let(:question) { create(:question, quizzes: [quiz], correct_answer: '正解') }
  let(:quiz_session) { create(:quiz_session, user:, quiz:) }

  describe 'バリデーションに関するテスト' do
    context '有効な場合' do
      it '回答テキストが存在すれば有効であること' do
        user_answer = UserAnswer.new(
          user:,
          quiz:,
          question:,
          quiz_session:,
          answer_text: '回答'
        )
        expect(user_answer).to be_valid
      end
    end
  end

  describe 'コールバックに関するテスト' do
    it '回答テキストが正解の場合、correctがtrueになること' do
      user_answer = UserAnswer.new(
        user:,
        quiz:,
        question:,
        quiz_session:,
        answer_text: '正解'
      )
      user_answer.save
      expect(user_answer.correct).to be true
    end

    it '回答テキストが正解でない場合、correctがfalseになること' do
      user_answer = UserAnswer.new(
        user:,
        quiz:,
        question:,
        quiz_session:,
        answer_text: '不正解'
      )
      user_answer.save
      expect(user_answer.correct).to be false
    end
  end

  describe 'アソシエーションに関するテスト' do
    it 'UserAnswerは1つのUserに属すること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'UserAnswerは1つのQuizに属すること' do
      assoc = described_class.reflect_on_association(:quiz)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'UserAnswerは1つのQuestionに属すること' do
      assoc = described_class.reflect_on_association(:question)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'UserAnswerは1つのQuizSessionに属すること' do
      assoc = described_class.reflect_on_association(:quiz_session)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
