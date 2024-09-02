require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションに関するテスト' do
    it '有効なユーザーが作成できること' do
      user = User.new(
        email: 'test@example.com',
        password: 'password',
        quiz_mode: 'default',
      )
      expect(user).to be_valid
    end

    it 'メールアドレスがない場合、無効であること' do
      user = User.new(
        email: '',
        password: 'password',
        quiz_mode: 'default'
      )
      expect(user).not_to be_valid
    end

    it 'パスワードがない場合、無効であること' do
      user = User.new(
        email: 'test@example.com',
        password: '',
        quiz_mode: 'default'
      )
      expect(user).not_to be_valid
    end
  end

  describe 'コールバックに関するテスト' do
    it 'ユーザー作成時にデフォルトのクイズモードが設定されること' do
      user = User.new(
        email: 'test@example.com',
        password: 'password'
      )
      user.save
      expect(user.quiz_mode).to eq('default')
    end
  end

  describe 'アソシエーションに関するテスト' do
    it 'Userは複数のQuizを持つことができる' do
      assoc = described_class.reflect_on_association(:quizzes)
      expect(assoc.macro).to eq :has_many
    end

    it 'Userは複数のFavoriteQuizを持つことができる' do
      assoc = described_class.reflect_on_association(:favorite_quizzes)
      expect(assoc.macro).to eq :has_many
    end

    it 'Userは複数のFavoriteQuizを通じて、複数のQuizをお気に入りにできること' do
      assoc = described_class.reflect_on_association(:favorite_quizzed)
      expect(assoc.macro).to eq :has_many
    end
  end
end
