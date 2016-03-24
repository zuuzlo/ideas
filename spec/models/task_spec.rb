require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to(:user) }
  it { should belong_to(:taskable) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:taskable_id) }
  it { should have_many(:tasks) }
  it { should have_many(:notes) }
  it { should have_many(:idea_links) }
  
  it do
    should validate_numericality_of(:percent_complete).
      only_integer
  end

  it do
    should validate_inclusion_of(:status).
    in_array(%w(Hold Active Complete))
  end

  context "test percent_complete" do
    let(:user1) { Fabricate(:user) }
    let(:task1) { Fabricate(:task, percent_complete: nil, user_id: user1.id) }
    
    it "should make percent_complete 0 if nil" do
      expect(task1.percent_complete).to eq(0)
    end
  end

  describe "#task_child?" do
    let(:user1) { Fabricate(:user) }
    let(:task1) { Fabricate(:task, percent_complete: 0, user_id: user1.id) }
    let(:task2) { Fabricate(:task, percent_complete: 0, user_id: user1.id) }
    before { task1.tasks << task2}

    it "task1 is not child task" do
      expect(task1.task_child?).to be false
    end

    it "task2 is a child task" do
      expect(task2.task_child?).to be true
    end
  end
end
