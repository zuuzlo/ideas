require 'rails_helper'

RSpec.describe IdeaLink, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:idea_linkable) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:idea_linkable_id) }
  it { should have_many(:idea_links) }

  it { should allow_value("http://cashback.allkohlscoupons.com/admin/activities").for(:link_url) }
  it { should_not allow_value("//hello.com").for(:link_url) }
end
