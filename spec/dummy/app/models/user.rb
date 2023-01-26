require 'devise'

class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
