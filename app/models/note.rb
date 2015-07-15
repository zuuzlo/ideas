class Note < ActiveRecord::Base
  belongs_to :user
  belongs_to :notable, polymorphic: true
  has_many :notes, as: :notable, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy
  has_many :idea_links, as: :idea_linkable, dependent: :destroy

  validates :title, presence: true
  validates_uniqueness_of :title, case_sensitive: false, scope: :user_id

  extend FriendlyId
  friendly_id :title, use: :scoped, scope: :user
end