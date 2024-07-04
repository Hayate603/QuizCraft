require 'rails_helper'

RSpec.describe QuizSession, type: :model do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz) }

  describe 'バリデーションに関するテスト' do
    context '有効な場合' do
      it '開始時間が存在すれば有効であること' do
        quiz_session = QuizSession.new(user:, quiz:, start_time: Time.current)
        expect(quiz_session).to be_valid
      end
    end

    context '無効な場合' do
      it '開始時間がなければ無効であること' do
        quiz_session = QuizSession.new(user:, quiz:)
        quiz_session.valid?
        expect(quiz_session.errors[:start_time]).to include("開始時間を入力してください")
      end
    end
  end

  describe 'アソシエーションに関するテスト' do
    it 'QuizSessionは1つのUserに属すること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'QuizSessionは1つのQuizに属すること' do
      assoc = described_class.reflect_on_association(:quiz)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'QuizSessionは複数のUserAnswersを持っていること' do
      assoc = described_class.reflect_on_association(:user_answers)
      expect(assoc.macro).to eq :has_many
    end
  end
end
