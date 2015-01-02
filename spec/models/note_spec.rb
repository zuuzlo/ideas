require 'rails_helper'

RSpec.describe Note, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:notable) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }
  it { should have_many(:notes) }
end