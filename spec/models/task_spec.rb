require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:taskable) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:taskable_id) }
  it { should have_many(:tasks) }
  
  it do
    should validate_numericality_of(:percent_complete).
      only_integer
  end

  it do
    should validate_inclusion_of(:status).
    in_array(%w(Hold Active Complete))
  end
end
