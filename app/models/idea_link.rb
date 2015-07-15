class IdeaLink < ActiveRecord::Base

  belongs_to :user
  belongs_to :idea_linkable, polymorphic: true
  has_many :idea_links, as: :idea_linkable, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: [:idea_linkable_id]
  
  validates_format_of :link_url, :with => URI::regexp(%w(http https))

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :idea_linkable_type],
      [:name, :idea_linkable_type, :idea_linkable_id],
      [:name, :idea_linkable_type, :idea_linkable_id, :id]
    ]
  end
end
