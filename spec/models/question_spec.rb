require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user: user) }

  describe "バリデーション" do
    context "有効な場合" do
      it "質問テキスト、正解がありクイズとの関連付けがされていれば有効であること" do
        question = Question.new(question_text: "Sample question", correct_answer: "Sample answer", quizzes: [quiz])
        expect(question).to be_valid
      end
    end

    context "無効な場合" do
      it "質問テキストがなければ無効であること" do
        question = Question.new(question_text: "", correct_answer: "Sample answer", quizzes: [quiz])
        expect(question).to be_invalid
        expect(question.errors[:question_text]).to include("を入力してください")
      end

      it "正解がなければ無効であること" do
        question = Question.new(question_text: "Sample question", correct_answer: "", quizzes: [quiz])
        expect(question).to be_invalid
        expect(question.errors[:correct_answer]).to include("を入力してください")
      end

      it "クイズに関連付けられていない場合は無効であること" do
        question = Question.new(question_text: "Sample question", correct_answer: "Sample answer", quizzes: [])
        expect(question).to be_invalid
        expect(question.errors[:quizzes]).to include("少なくとも1つのクイズに関連付けられている必要があります")
      end
    end
  end

  describe "コールバック" do
    context "関連付けられているクイズがない場合" do
      it "質問が削除されること" do
        question = create(:question, question_text: "Sample question", correct_answer: "Sample answer", quizzes: [quiz])
        question.quizzes.clear
        expect { question.destroy }.to change { Question.count }.by(-1)
      end
    end

    context "他のクイズに関連付けられている場合" do
      it "質問が削除されないこと" do
        question = create(:question, question_text: "Sample question", correct_answer: "Sample answer", quizzes: [quiz])
        another_quiz = create(:quiz, user: user, title: "Another Quiz")
        create(:quiz_question, quiz: another_quiz, question: question)
        expect { question.destroy }.to_not change { Question.count }
      end
    end
  end

  describe "アソシエーション" do
    it "Questionは複数のQuizに属すること" do
      assoc = described_class.reflect_on_association(:quizzes)
      expect(assoc.macro).to eq :has_many
    end

    it "QuestionはQuizQuestionを通じてQuizに関連付けられていること" do
      assoc = described_class.reflect_on_association(:quiz_questions)
      expect(assoc.macro).to eq :has_many
    end
  end
end
