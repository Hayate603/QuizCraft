class User < ApplicationRecord
  has_many :quizzes, dependent: :destroy
  has_many :favorite_quizzes, dependent: :destroy
  has_many :favorite_quizzed, through: :favorite_quizzes, source: :quiz

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]

  # クイズの形式の定数（英語）
  QUIZ_MODES = {
    default: 'default',
    self_grading: 'self_grading'
  }.freeze

  # クイズモードの日本語ラベル
  QUIZ_MODE_LABELS = {
    default: '入力モード',
    self_grading: '自己採点モード'
  }.freeze

  # バリデーション (クイズ形式)
  validates :quiz_mode, inclusion: { in: QUIZ_MODES.values }

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email)

    if user
      update_user_from_omniauth(user, auth)
    else
      user = create_user_from_omniauth(auth)
    end

    user
  rescue Net::OpenTimeout
    nil
  end

  class << self
    private

    def update_user_from_omniauth(user, auth)
      user.update(provider: auth.provider, uid: auth.uid, username: auth.info.name)
      user
    end

    def create_user_from_omniauth(auth)
      user = initialize_user_from_auth(auth)
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.save!
      user
    end

    def initialize_user_from_auth(auth)
      User.new(
        provider: auth.provider,
        uid: auth.uid,
        username: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        quiz_mode: User::QUIZ_MODES[:default]
      )
    end
  end
end
