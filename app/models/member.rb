class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:stripe_connect]

       validates_presence_of :name

  has_one :profile, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :reservations
end
