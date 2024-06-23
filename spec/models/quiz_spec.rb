require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe 'バリデーションに関するテスト' do
    context '有効な場合' do
      it 'タイトルと説明があれば有効であること' do
        quiz = Quiz.new(title: '有効なタイトル', description: '有効な説明', user: user)
        expect(quiz).to be_valid
      end

      it '他のユーザーなら同じタイトルのクイズでも作成できること' do
        Quiz.create!(title: '同じタイトル', description: '有効な説明', user: user)
        quiz = Quiz.new(title: '同じタイトル', description: '有効な説明', user: another_user)
        expect(quiz).to be_valid
      end
    end

    context '無効な場合' do
      it 'タイトルがなければ無効であること' do
        quiz = Quiz.new(description: '有効な説明', user: user)
        quiz.valid?
        expect(quiz.errors[:title]).to include("タイトルを入力してください")
      end

      it '説明がなければ無効であること' do
        quiz = Quiz.new(title: '有効なタイトル', user: user)
        quiz.valid?
        expect(quiz.errors[:description]).to include("説明を入力してください")
      end

      it '同じユーザーが同じタイトルのクイズを作成できないこと' do
        Quiz.create!(title: '同じタイトル', description: '有効な説明', user: user)
        quiz = Quiz.new(title: '同じタイトル', description: '有効な説明', user: user)
        quiz.valid?
        expect(quiz.errors[:title]).to include("同じタイトルというタイトルのクイズは既に存在します。別のタイトルを入力してください。")
      end
    end
  end

  describe '関連付けに関するテスト' do
    let(:quiz) { FactoryBot.create(:quiz, user: user) }

    it 'ユーザーに属していること' do
      expect(quiz.user).to eq(user)
    end

    # これらのテストは、question と quiz_question モデルが作成された後に有効にしてください
    # it '複数のquiz_questionsを持っていること' do
    #   quiz_question = FactoryBot.create(:quiz_question, quiz: quiz)
    #   expect(quiz.quiz_questions).to include(quiz_question)
    # end

    # it 'quiz_questionsを通じて複数のquestionsを持っていること' do
    #   question = FactoryBot.create(:question)
    #   quiz_question = FactoryBot.create(:quiz_question, quiz: quiz, question: question)
    #   expect(quiz.questions).to include(question)
    # end
  end
end
