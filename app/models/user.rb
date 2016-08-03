class User < ActiveRecord::Base
  has_many :white_games, class_name: 'Game', foreign_key: 'white_user_id'
  has_many :black_games, class_name: 'Game', foreign_key: 'black_user_id'
  has_many :moves
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
