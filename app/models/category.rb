class Category < ActiveRecord::Base
  belongs_to :user
  has_many :notes, as: :notable, dependent: :destroy
  has_and_belongs_to_many :ideas, -> { uniq }
  
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: :user_id

  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :user
end
