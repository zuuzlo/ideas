require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  describe "GET new" do
    context "unauthenticated user" do
      let(:user1) { Fabricate(:user) }
      let(:idea1) { Fabricate(:idea, user_id: user1.id) }
      
      it_behaves_like "require_sign_in" do
        let(:action) { xhr :get, :new, idea_id: idea1.id, format: 'js' }
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
    context "good data" do
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

    context "bad data" do
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
      before do
        patch :update, task: { name: nil, description: 'edit task description', status: "Active", assigned_by: user1.id, assigned_to: user1.id, user_id: user1.id, percent_complete: 10, start_date: Time.now, finish_date: Time.now + 5.days, completion_date: Time.now + 10.days },id: task1.id, idea_id: idea1.id, format: 'js'
      end

      it "sets @task and finds proper task" do
        expect(assigns(:task)).to eq(task1)
      end

      it "sets @taskable to proper idea" do
        expect(assigns(:taskable)).to eq(idea1)
      end

      it "renders edit" do
        expect(response).to render_template :edit
      end

      it "task is not updated" do
        expect(Task.find(task1.id).name).to eq(task1.name)
      end

      it "sets flash success" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end