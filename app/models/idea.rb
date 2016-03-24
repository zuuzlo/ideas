class Idea < ActiveRecord::Base
  belongs_to :user
  has_many :notes, as: :notable, dependent: :destroy
  has_many :tasks,-> { order("position ASC") }, as: :taskable, dependent: :destroy
  has_many :idea_links, as: :idea_linkable, dependent: :destroy
  has_and_belongs_to_many :categories, -> { uniq }
  
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: :user_id
  validates :status, :inclusion => { :in => %w(Hold Active Complete) }
  
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :user

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
