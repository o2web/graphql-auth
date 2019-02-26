require 'devise'

class User < ApplicationRecord
  extend Devise::Models

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :lockable, :registerable,
         :recoverable, :rememberable, :validatable
end
