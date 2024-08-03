require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe 'バリデーションに関するテスト' do
    context '有効な場合' do
      it 'タイトルと説明があれば有効であること' do
        quiz = Quiz.new(title: '有効なタイトル', description: '有効な説明', user:)
        expect(quiz).to be_valid
      end

      it '説明がなくても有効であること' do
        quiz = Quiz.new(title: '有効なタイトル', user:)
        expect(quiz).to be_valid
      end

      it '他のユーザーなら同じタイトルのクイズでも作成できること' do
        Quiz.create!(title: '同じタイトル', description: '有効な説明', user:)
        quiz = Quiz.new(title: '同じタイトル', description: '有効な説明', user: another_user)
        expect(quiz).to be_valid
      end
    end

    context '無効な場合' do
      it 'タイトルがなければ無効であること' do
        quiz = Quiz.new(description: '有効な説明', user:)
        quiz.valid?
        expect(quiz.errors[:title]).to include("タイトルを入力してください")
      end

      it '同じユーザーが同じタイトルのクイズを作成できないこと' do
        Quiz.create!(title: '同じタイトル', description: '有効な説明', user:)
        quiz = Quiz.new(title: '同じタイトル', description: '有効な説明', user:)
        quiz.valid?
        expect(quiz.errors[:title]).to include("同じタイトルというタイトルのクイズは既に存在します。別のタイトルを入力してください。")
      end
    end
  end

  describe 'アソシエーションに関するテスト' do
    it 'Quizは1つのUserに属すること' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'Quizは複数のQuizQuestionsを持っていること' do
      assoc = described_class.reflect_on_association(:quiz_questions)
      expect(assoc.macro).to eq :has_many
    end

    it 'QuizはQuizQuestionsを通じて複数のQuestionsを持っていること' do
      assoc = described_class.reflect_on_association(:questions)
      expect(assoc.macro).to eq :has_many
    end
  end
end
