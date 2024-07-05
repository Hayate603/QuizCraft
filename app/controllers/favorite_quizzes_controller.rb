class FavoriteQuizzesController < ApplicationController
  before_action :authenticate_user!

  def create
    quiz = Quiz.find(params[:quiz_id])
    current_user.favorite_quizzes.create!(quiz: quiz)
    redirect_to quiz, notice: 'クイズをお気に入りに追加しました。'
  end

  def destroy
    quiz = Quiz.find(params[:quiz_id])
    current_user.favorite_quizzes.find_by(quiz: quiz).destroy
    redirect_to quiz, notice: 'クイズをお気に入りから削除しました。'
  end
end
