require 'rails_helper'

RSpec.describe Category, :type => :model do
  it { should belong_to(:user) }
  it { should have_many(:notes) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id) }
end
