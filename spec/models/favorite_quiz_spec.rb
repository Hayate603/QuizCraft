require 'rails_helper'

RSpec.describe FavoriteQuiz, type: :model do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user:) }

  describe "バリデーション" do
    context "有効な場合" do
      it "ユーザーとクイズが関連付けられていれば有効であること" do
        favorite_quiz = FavoriteQuiz.new(user:, quiz:)
        expect(favorite_quiz).to be_valid
      end
    end

    context "無効な場合" do
      it "ユーザーがなければ無効であること" do
        favorite_quiz = FavoriteQuiz.new(user: nil, quiz:)
        expect(favorite_quiz).to be_invalid
        expect(favorite_quiz.errors[:user]).to include("ユーザー情報が見つかりません")
      end

      it "クイズがなければ無効であること" do
        favorite_quiz = FavoriteQuiz.new(user:, quiz: nil)
        expect(favorite_quiz).to be_invalid
        expect(favorite_quiz.errors[:quiz]).to include("クイズ情報が見つかりません")
      end

      it "同じユーザーとクイズの組み合わせは一意でなければ無効であること" do
        FavoriteQuiz.create!(user:, quiz:)
        duplicate_favorite_quiz = FavoriteQuiz.new(user:, quiz:)
        expect(duplicate_favorite_quiz).to be_invalid
        expect(duplicate_favorite_quiz.errors[:user_id]).to include("同じユーザーとクイズの組み合わせはすでに存在します")
      end
    end
  end

  describe "アソシエーション" do
    it "ユーザーに属すること" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it "クイズに属すること" do
      assoc = described_class.reflect_on_association(:quiz)
      expect(assoc.macro).to eq :belongs_to
    end
  end
end
