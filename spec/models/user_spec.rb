require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many(:notes) }
  it { should have_many(:categories) }
  it { should have_many(:ideas) }
  it { should have_many(:tasks) }
  it { should have_many(:idea_links) }
end
