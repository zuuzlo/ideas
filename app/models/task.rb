class Task < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :taskable, polymorphic: true
  has_many :tasks, as: :taskable, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: [:taskable_id]
  validates :status, :inclusion => { :in => %w(Hold Active Complete) }
  validates :percent_complete, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :taskable_type],
      [:name, :taskable_type, :taskable_id],
      [:name, :taskable_type, :taskable_id, :id]
    ]
  end
end
