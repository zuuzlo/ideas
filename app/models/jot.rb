class Jot < ActiveRecord::Base
  belongs_to :user
  validates :context, presence: true
  validates :status, :inclusion => { :in => %w(Hold Active Complete) }
  acts_as_list scope: :user
end
