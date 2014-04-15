class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  has_one :account

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :email,
            uniqueness: {case_sensitive: true},
            presence: true,
            format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :password,
            presence: true,
            confirmation: true

  validates :password_confirmation,
            presence: true
end
