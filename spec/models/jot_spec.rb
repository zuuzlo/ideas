require 'rails_helper'

RSpec.describe Jot, :type => :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:context) }
  it do
    should validate_inclusion_of(:status).
    in_array(%w(Hold Active Complete))
  end
end
