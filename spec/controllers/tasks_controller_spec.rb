require 'rails_helper'
require 'time'

RSpec.describe TasksController, :type => :controller do
  describe "GET new" do
    context "unauthenticated user" do
      let(:user1) { Fabricate(:user) }
      let(:idea1) { Fabricate(:idea, user_id: user1.id) }
      let(:task1) { Fabricate(:task, user_id: user1.id) }
      
      it_behaves_like "require_sign_in" do
        let(:action) { get :new, idea_id: idea1.id }
      end
    end

    context "authenticated user" do
      context "good data" do
        let(:user1) { Fabricate(:user) }
        let(:idea1) { Fabricate(:idea, user_id: user1.id) }

        before do
          sign_in user1
          xhr :get, :new, idea_id: idea1.id, format: 'js'
        end

        it "sets @task to instance of Task" do
          expect(assigns(:task)).to be_a Task
        end

        it "sets @task.user_id to current user" do
          expect(assigns(:task).user_id).to eq(user1.id)
        end

        it "renders new" do
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "POST create" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    before { sign_in user1 }
    context "valid data" do
      before do
        post :create, task: { name: "New Task", description: 'new task description', status: "Active", assigned_by: user1.id, assigned_to: user1.id, user_id: user1.id, percent_complete: 10, start_date: Time.now, finish_date: Time.now + 5.days, completion_date: Time.now + 10.days }, idea_id: idea1.id, format: 'js'
      end
      it "loads @taskable" do
        expect(assigns(:taskable)).to eq(idea1)
      end

      it "creates a new task" do
        expect(Task.all.count).to eq(1)
      end

      it "flash success task created." do
        expect(flash[:success]).to be_present
      end

      it "render create" do
        expect(response).to render_template :create
      end
    end

    context "invalid data" do
      before do
        post :create, task: { name: nil, description: 'new task description', status: "Active", assigned_by: user1.id, assigned_to: user1.id, user_id: user1.id, percent_complete: 10, start_date: Time.now, finish_date: Time.now + 5.days, completion_date: Time.now + 10.days }, idea_id: idea1.id, format: 'js'
      end

      it "it does not creates a new task" do
        expect(Task.all.count).to eq(0)
      end

      it "flash danger task created." do
        expect(flash[:danger]).to be_present
      end

      it "render edit" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "GET edit" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id) }
      
    before do
      idea1.tasks << task1
      sign_in user1
      xhr :get, :edit, id: task1.id, idea_id: idea1.id, format: 'js'
    end

    it "sets @task and finds proper task" do
      expect(assigns(:task)).to eq(task1)
    end

    it "renders edit" do
      expect(response).to render_template :edit
    end

    it "sets @taskable to proper idea" do
      expect(assigns(:taskable)).to eq(idea1)
    end
  end

  describe "PATCH update" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id) }

    before do
      idea1.tasks << task1
      sign_in user1
    end

    context "valid input" do
      before do
        patch :update, task: { name: "Edit Task", description: 'edit task description', status: "Active", assigned_by: user1.id, assigned_to: user1.id, user_id: user1.id, percent_complete: 10, start_date: Time.now, finish_date: Time.now + 5.days, completion_date: Time.now + 10.days },id: task1.id, idea_id: idea1.id, format: 'js'
      end

      it "sets @task and finds proper task" do
        expect(assigns(:task)).to eq(task1)
      end

      it "sets @taskable to proper idea" do
        expect(assigns(:taskable)).to eq(idea1)
      end

      it "renders create" do
        expect(response).to render_template :update
      end

      it "updates the task" do
        expect(assigns(:task).name).to eq("Edit Task")
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "invalid input" do
      before(:example) do
        patch :update, task: { name: nil, description: 'edit task description', status: "Active", assigned_by: user1.id, assigned_to: user1.id, user_id: user1.id, percent_complete: 10, start_date: Time.now, finish_date: Time.now + 5.days, completion_date: Time.now + 10.days },id: task1.id, idea_id: idea1.id, format: 'js'
      end

      it "sets @task and finds proper task" do
        expect(assigns(:task)).to eq(task1)
      end

      it "sets @taskable to proper idea" do
        expect(assigns(:taskable)).to eq(idea1)
      end

      it "renders update" do
        expect(response).to render_template :update
      end

      it "task is not updated" do
        expect(Task.find(task1.id).name).to eq(task1.name)
      end

      it "sets flash success" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE destroy" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id) }
    let(:task2) { Fabricate(:task, user_id: user1.id) }

    before do
      idea1.tasks << [task1, task2]
      sign_in user1
      delete :destroy, id: task1.id, idea_id: idea1.id, format: 'js'
    end

    it "finds correct task to delete and sets @task" do
      expect(assigns(:task)).to eq(task1)
    end

    it "loads notable parent of the note." do
      expect(assigns(:taskable)).to eq(idea1)
    end

    it "sets flash success" do
      expect(flash[:success]).to be_present
    end

    it "removes the record" do
      expect(Task.all.count).to eq(1)
    end

    it "renders destroy" do
      expect(response).to render_template("destroy")
    end
  end

  describe "POST update_task" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id, status: "Hold") }
    let(:task2) { Fabricate(:task, user_id: user1.id) }

    before do
      idea1.tasks << task1
      idea1.tasks << task2
      sign_in user1
    end
    
    context "valid input" do
      context "task is complete" do
        before do
          post :update_task, id: task1.id, idea_id: idea1.id, percent_complete: 100, status: "Complete", format: 'js'
        end
        it "sets @task" do
          expect(assigns(:task)).to eq(task1)
        end

        it "sets @taskable" do
          expect(assigns(:taskable)).to eq(idea1)
        end

        it "updates task % complete" do
          expect(Task.find_by_id(task1.id).percent_complete).to eq(100)
        end

        it "updates task status" do
          expect(Task.find_by_id(task1.id).status).to eq("Complete")
        end

        it "updates completion_date if task is complete" do
          expect(Task.find_by_id(task1.id).completion_date.to_s).to eq(Time.now.strftime "%F")
        end

        it "renders update_task" do
          expect(response).to render_template :update_task
        end

        it "flash success should be present" do
          expect(flash[:success]).to be_present
        end
      end

      context "task is not complete" do
        before do
          post :update_task, id: task1.id, idea_id: idea1.id, percent_complete: 99, status: "Active", format: 'js'
        end

        it "sets percent complete" do
          expect(Task.find_by_id(task1.id).percent_complete).to eq(99)
        end

        it "sets task status" do
          expect(Task.find_by_id(task1.id).status).to eq("Active")
        end

        it "doesn't change completion_date" do
          expect(Task.find_by_id(task1.id).completion_date).to be_nil
        end

        it "flash success should be present" do
          expect(flash[:success]).to be_present
        end
      end
    end

    context "input not valid" do
      before do
          post :update_task, id: task1.id, idea_id: idea1.id, percent_complete: -1, status: "Active", format: 'js'
      end

      it "task is not updated" do
        expect(Task.find_by_id(task1.id).percent_complete).to eq(25)
      end

      it "flash danger should be present" do
          expect(flash[:danger]).to be_present
      end
    end
  end

  describe "GET more_less" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id, status: "Hold") }
    let(:task2) { Fabricate(:task, user_id: user1.id) }

    before do
      idea1.tasks << task1
      idea1.tasks << task2
      sign_in user1
      xhr :get, :more_less, id: task1.id, idea_id: idea1.id, format: 'js'
    end

    it "sets @task and finds proper task" do
      expect(assigns(:task)).to eq(task1)
    end

    it "sets @taskable to idea1" do
      expect(assigns(:taskable)).to eq(idea1)
    end

    it "renders more_less" do
      expect(response).to render_template :more_less
    end
  end

  describe "GET show" do
    let(:user1) { Fabricate(:user) }
    let(:taskp) { Fabricate(:task, user_id: user1.id) }
    (1..3).each do |i|
      let("task#{i}".to_sym) { Fabricate(:task, name: "task#{i}", user_id: user1.id) }
      let("note#{i}".to_sym) { Fabricate(:note, title: "note#{i}", user_id: user1.id) }
      let("idea_link#{i}".to_sym) { Fabricate(:idea_link, name: "Idea Link#{i}", user_id: user1.id) }
    end

    before do
      taskp.tasks << [task1, task2, task3]
      taskp.notes << [note1, note2, note3]
      taskp.idea_links << [idea_link1, idea_link2, idea_link3]
      sign_in user1
      xhr :get, :show, id: taskp.id, format: 'html'
    end

    it "sets @parent to show task" do
      expect(assigns(:parent)).to eq(taskp)
    end

    it "loads children tasks into @tasks" do
      expect(assigns(:tasks)).to match_array([task1, task2, task3])
    end

    it "loads children notes into @notes" do
      expect(assigns(:notes)).to match_array([note1, note2, note3])
    end

    it "loads children idea_links into @idea_links" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2, idea_link3])
    end
    it "renders show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET show_children" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:task1) { Fabricate(:task, user_id: user1.id, status: "Hold") }
    let(:task2) { Fabricate(:task, user_id: user1.id) }

    before do
      idea1.tasks << task1
      idea1.tasks << task2
      sign_in user1
      xhr :get, :show_children, id: task1.id, format: 'js'
    end

    it "sets @task and finds proper task" do
      expect(assigns(:task)).to eq(task1)
    end

    it "renders more_less" do
      expect(response).to render_template :show_children
    end
  end

  describe "GET move_up" do
    let(:user1) { Fabricate(:user) }
    let!(:taskp) { Fabricate(:task, name: "parent task",  user_id: user1.id) }
    
    before(:example) do
      (1..6).each do |i|
        status = ["Active", "Hold"]
        si = i%2
        Fabricate(:task, name: "task#{i}", status: status[si], user_id: user1.id)
        taskp.tasks << Task.last
      end
      sign_in user1
    end

    context "All tab" do

      context "task is any where but top" do
        before(:example) do
          xhr :get, :tab_all, format: 'js'
          xhr :get, :move_up, id: Task.where(name: "task2").first.id, format: 'js'
        end
        
        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task2")
        end

        it "move task2 to postion 1" do
          expect(assigns(:task).first?).to be true
        end

        it "at itentifies next" do
          expect(assigns(:next).name).to eq("task1")
        end

        it "moved task1 down to spot 2" do
          expect(Task.where(name: "task1").first.position).to eq(2)
        end

        it "flash success" do
          expect(flash[:success]).to be_present
        end

        it "@tab is 'All'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("All")
        end

        it "assign @above_task to eq @task" do
          expect(assigns(:above_task).name).to eq("task2")
        end
      end

      context "task is top" do
        
        before(:example) do
          xhr :get, :tab_all, format: 'js'
          xhr :get, :move_up, id: Task.where(name: "task1").first.id, format: 'js'
        end

        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task1")
        end

        it "doesn't move top task" do
          expect(assigns(:task).first?).to be true
        end

        it "flash danger" do
          expect(flash[:danger]).to be_present
        end
        
        it "renders nothing" do
          expect(response.body).to be_blank
        end
      end
    end

    context "Hold tab" do
      context "task is ordered in middle atleast 1 away from next" do
        before(:example) do
          xhr :get, :tab_hold, format: 'js'
          xhr :get, :move_up, id: Task.where(name: "task5").first.id, format: 'js'
        end

        it "@tab is 'Hold'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("Hold")
        end

        it "find status @task" do
          expect(assigns(:task).status).to eq("Hold")
        end

        it "find next of @next" do
          expect(assigns(:next)).to eq(Task.where(name: "task3").first)
        end

        it "puts task5 at postion 3" do
          expect(assigns(:task).position).to eq(3)
        end

        it "puts task3 at position 5" do
          expect(assigns(:next).position).to eq(5)
        end

        it "@above_task is task4" do
          expect(assigns(:above_task)).to eq(Task.where(name: "task4").first)
        end
      end

      context "task is ordered top of hold but not first?" do
        before(:example) do
          xhr :get, :tab_active, format: 'js'
          xhr :get, :move_up, id: Task.where(name: "task2").first.id, format: 'js'
        end

        it "@tab is 'Active'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("Active")
        end

        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task2")
        end

        it "doesn't move top task" do
          expect(assigns(:task).position).to be (2)
        end

        it "flash danger" do
          expect(flash[:danger]).to be_present
        end
        
        it "renders nothing" do
          expect(response.body).to be_blank
        end
      end
    end
  end

  describe "GET move_down" do
    let(:user1) { Fabricate(:user) }
    let!(:taskp) { Fabricate(:task, user_id: user1.id) }
    
    before(:example) do
      (1..6).each do |i|
        status = ["Active", "Hold"]
        si = i%2
        Fabricate(:task, name: "task#{i}", status: status[si], user_id: user1.id)
        taskp.tasks << Task.last
      end

      sign_in user1
    end

    context "All tab" do

      context "task is any where but top" do
        before(:example) do
          xhr :get, :tab_all, format: 'js'
          xhr :get, :move_down, id: Task.where(name: "task5").first.id, format: 'js'
        end
        
        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task5")
        end

        it "move task2 to postion 1" do
          expect(assigns(:task).last?).to be true
        end

        it "at itentifies next" do
          expect(assigns(:next).name).to eq("task6")
        end

        it "moved task6 up to spot 5" do
          expect(Task.where(name: "task6").first.position).to eq(5)
        end

        it "flash success" do
          expect(flash[:success]).to be_present
        end

        it "@tab is 'All'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("All")
        end

        it "assign @above_task to eq @task" do
          expect(assigns(:above_task).name).to eq("task5")
        end
      end

      context "task is bottom" do
        
        before(:example) do
          xhr :get, :tab_all, format: 'js'
          xhr :get, :move_down, id: Task.where(name: "task6").first.id, format: 'js'
        end

        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task6")
        end

        it "doesn't move top task" do
          expect(assigns(:task).last?).to be true
        end

        it "flash danger" do
          expect(flash[:danger]).to be_present
        end
        
        it "renders nothing" do
          expect(response.body).to be_blank
        end
      end
    end

    context "Hold tab" do
      context "task is ordered in middle atleast 1 away from next" do
        before(:example) do
          xhr :get, :tab_hold, format: 'js'
          xhr :get, :move_down, id: Task.where(name: "task3").first.id, format: 'js'
        end

        it "@tab is 'Hold'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("Hold")
        end

        it "find status @task" do
          expect(assigns(:task).status).to eq("Hold")
        end

        it "find next of @next" do
          expect(assigns(:next)).to eq(Task.where(name: "task5").first)
        end

        it "puts task3 at postion 5" do
          expect(assigns(:task).position).to eq(5)
        end

        it "puts task5 at position 3" do
          expect(assigns(:next).position).to eq(3)
        end

        it "@above_task is task4" do
          expect(assigns(:above_task)).to eq(Task.where(name: "task4").first)
        end
      end

      context "task is ordered top of hold but not first?" do
        before(:example) do
          xhr :get, :tab_hold, format: 'js'
          xhr :get, :move_down, id: Task.where(name: "task5").first.id, format: 'js'
        end

        it "@tab is 'Active'" do
          expect(TasksController.class_variable_get(:@@tab)).to eq("Hold")
        end

        it "finds correct task and set @task" do
          expect(assigns(:task).name).to eq("task5")
        end

        it "doesn't move top task" do
          expect(assigns(:task).position).to be (5)
        end

        it "flash danger" do
          expect(flash[:danger]).to be_present
        end
        
        it "renders nothing" do
          expect(response.body).to be_blank
        end
      end
    end
  end
end
