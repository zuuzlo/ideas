class Task < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :taskable, polymorphic: true

  acts_as_list scope: :taskable
  
  has_many :tasks,-> { order("position ASC") }, as: :taskable, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy
  has_many :idea_links, as: :idea_linkable, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false, scope: [:taskable_id]
  validates :status, :inclusion => { :in => %w(Hold Active Complete) }
  validates :percent_complete, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  before_validation :ensure_percent_complete_has_value, :ensure_status_has_value
  
  #extend FriendlyId
  #friendly_id :slug_candidates, use: :slugged

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def task_child?
    if self.taskable.is_a? Task
      true
    else
      false
    end
  end

  def over_due?
    
    if self.finish_date  && self.status == "Active"
      if self.finish_date < Time.now
        true
      else
        false
      end  
    else
      false
    end
  end

  protected
    def slug_candidates
      [
        :name,
        [:name, :taskable_type],
        [:name, :taskable_type, :taskable_id],
        [:name, :taskable_type, :taskable_id, :id]
      ]
    end

    def ensure_percent_complete_has_value
      self.percent_complete ||= 0
    end

    def ensure_status_has_value
      self.status ||= "Hold"
    end
end
