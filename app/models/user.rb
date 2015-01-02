class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  
  extend FriendlyId
  friendly_id :email, use: :slugged

  has_many :categories, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :ideas, dependent: :destroy
  has_many :tasks, dependent: :destroy
end
