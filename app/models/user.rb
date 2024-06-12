class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :omniauthable,
         omniauth_providers: %i[google_oauth2 facebook]

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      user.update(provider: auth.provider, uid: auth.uid, username: auth.info.name)
    else
      user = User.create!(
        provider: auth.provider,
        uid: auth.uid,
        username: auth.info.name,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      user.save!
    end

    user
  rescue Net::OpenTimeout
    nil
  end
end
