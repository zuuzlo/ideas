require 'rails_helper'

RSpec.describe TasksHelper, :type => :helper do
  describe "#taskable_link" do
    let(:user1) { Fabricate(:user) }
    let!(:task1) { Fabricate(:task, user_id: user1.id, ) }
    it "returns line to notable" do
      expect(helper.taskable_link("Task", task1.id)).to eq("<a href=\"/tasks/#{task1.id}\">Link to Parent</a>")
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

    context "has one tasks" do
      let(:task1) { Fabricate(:task, name: "task1", percent_complete: 0,  user_id: user1.id) }


      before(:example) do
        taskp.tasks << task1
      end

      it "returns percent complete of zero" do
        expect(helper.tasks_percent_complete_total(taskp.tasks)).to eq(0)
      end
    end
  end

  describe "row_class_task" do
    let(:user1) { Fabricate(:user) }
    let(:task1) { Fabricate(:task, name: "task1", status: "Hold",  user_id: user1.id) }

    it "staus Hold returns row-warning" do
      expect(helper.row_class_task(task1)).to eq("row-warning")
    end

    it "status Complete returns row-info" do
      task1.update(status: "Complete")
      expect(helper.row_class_task(task1)).to eq("row-info")
    end

    it "status Active returns row-success" do
      task1.update(status: "Active")
      expect(helper.row_class_task(task1)).to eq("row-success")
    end
  end
end
