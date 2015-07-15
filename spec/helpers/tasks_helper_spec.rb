require 'rails_helper'

RSpec.describe TasksHelper, :type => :helper do
  describe "#taskable_link" do
    let(:user1) { Fabricate(:user) }
    let!(:task1) { Fabricate(:task, user_id: user1.id, ) }
    it "returns line to notable" do
      expect(helper.taskable_link("Task", task1.id)).to eq("<a href=\"/tasks/#{task1.slug}\">Link to Parent</a>")
    end
  end

  describe "#tasks_percent_complete_total" do
    let(:user1) { Fabricate(:user) }
    let(:taskp) { Fabricate(:task, user_id: user1.id) }
    
    context "has tasks" do
      
      (1..3).each do |i|
        let("task#{i}".to_sym) { Fabricate(:task, name: "task#{i}", percent_complete: i*10,  user_id: user1.id) }
      end

      before do
        taskp.tasks << [task1, task2, task3]
      end

      it "returns percent complete of all task" do
        expect(helper.tasks_percent_complete_total(taskp.tasks)).to eq(20)
      end
    end
    
    context "has no tasks" do
      it "returns percent complete of zero" do
        expect(helper.tasks_percent_complete_total(taskp.tasks)).to eq(0)
      end
    end
  end
end
