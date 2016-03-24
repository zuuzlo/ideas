class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :categories, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :ideas, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :idea_links, dependent: :destroy
  has_many :jots, -> { order(position: :asc) }, dependent: :destroy

  extend FriendlyId
  friendly_id :email, use: :slugged

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
