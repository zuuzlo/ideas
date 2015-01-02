require 'rails_helper'

RSpec.describe Idea, :type => :model do
  it { should belong_to(:user) }
  it { should have_many(:notes) }
  it { should have_many(:tasks) }
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:categories) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
  it do
    should validate_inclusion_of(:status).
    in_array(%w(Hold Active Complete))
  end
end
