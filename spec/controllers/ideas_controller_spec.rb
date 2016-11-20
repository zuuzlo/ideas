require 'rails_helper'

RSpec.describe IdeasController, :type => :controller do

  describe "GET new" do
    let!(:user1) { Fabricate(:user) }

    before do
      sign_in user1
      xhr :get, :new
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @idea to instance of Idea" do
      expect(assigns(:idea)).to be_a Idea
    end

    it "renders new" do
      expect(response).to render_template :new
    end
  end

  describe "GET index" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
      let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
    end

    before do
      sign_in user1
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @ideas to all users ideas" do
      expect(assigns(:ideas).count).to eq(3)
    end
  end

  describe "GET show" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
        let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
    end
    let!(:note1) { Fabricate(:note, user_id: user1.id) }
    let!(:note2) { Fabricate(:note, user_id: user1.id) }
    let!(:task1) { Fabricate(:task, user_id: user1.id) }
    let!(:task2) { Fabricate(:task, user_id: user1.id) }
    let!(:idea_link1) { Fabricate(:idea_link, user_id: user1.id) }
    let!(:idea_link2) { Fabricate(:idea_link, user_id: user1.id) }
    before do 
      sign_in user1
      idea1.notes << [note1, note2]
      idea1.tasks << [task1, task2]
      idea1.idea_links << [idea_link1, idea_link2]
      xhr :get, :show, id: idea1.id, format: 'html'
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @idea" do
      expect(assigns(:idea)).to eq(idea1)
    end
    it "sets @notes" do
      expect(assigns(:idea).notes).to match_array([note2, note1])
    end

    it "sets @note" do
      expect(assigns(:note)).to be_a Note
    end

    it "loads idea tasks into @tasks" do
      expect(assigns(:tasks).count).to eq(2)
    end

    it "sets @task" do
      expect(assigns(:task)).to be_a Task
    end

    it "sets @idea_link" do
      expect(assigns(:idea_link)).to be_a IdeaLink
    end

    it "loads idea idea_links into @idea_link" do
      expect(assigns(:idea_links)).to match_array([idea_link1, idea_link2])
    end
  end

  describe "GET edit" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
        let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
    end
    before do 
      sign_in user1
      xhr :get, :edit, id: idea1.id, format: 'js'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @idea to idea to be edited" do
      expect(assigns(:idea)).to eq(idea1)
    end

    it "renders edit" do
      expect(response).to render_template :edit
    end
  end

  describe "POST create" do
    context "authorized user" do
      let!(:user1) { Fabricate(:user) }
      let!(:cat1) { Fabricate(:category, user_id: user1.id) }
      let!(:cat2) { Fabricate(:category, user_id: user1.id) }
      (1..3).each do |i|
          let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
      end
      before { sign_in user1 }

      context "valid input" do
        before do
          post :create, idea: Fabricate.attributes_for(:idea, user_id: user1.id, category_ids: [cat1.id, cat2.id]), format: 'js'
        end
        
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "@idea is an instance of Idea" do
          expect(assigns(:idea)).to be_a Idea
        end

        it "creates a new idea" do
          expect(Idea.count).to eq(4)
        end

        it "flashes success message" do
          expect(flash[:success]).to be_present
        end

        it "renders create" do
          expect(response).to render_template "create"
        end

        it "sets @ideas" do
          expect(assigns(:ideas).count).to eq(4)
        end

        it "adds categories to idea" do
          expect(assigns(:idea).categories.count).to eq(2)
        end
      end

      context "invalid input" do
        before do
          post :create, idea: Fabricate.attributes_for(:idea, name: nil, user_id: user1.id), format: 'js'
        end

        it "doesn't create a new idea" do
          expect(Idea.count).to eq(3)
        end

        it "flashes danger" do
          expect(flash[:danger]).to be_present
        end

        it "renders edit" do
          expect(response).to render_template "edit"
        end
      end
    end

    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
    end
  end

  describe "PATCH update" do
    context "authorized user" do
      let!(:user1) { Fabricate(:user) }
      let!(:cat1) { Fabricate(:category, user_id: user1.id) }
      let!(:cat2) { Fabricate(:category, user_id: user1.id) }
      (1..3).each do |i|
        let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
      end

      before do
        sign_in user1
        idea1.categories << cat1
      end

      context "valid input no name change" do
        before do
          patch :update, idea: {name: idea1.name, description: "changed", category_ids: [ "", cat1.id, cat2.id] }, id: idea1.id, format: 'js'
        end
        
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "@idea find idea to be updated" do
          expect(assigns(:idea)).to eq(idea1)
        end

        it "updates idea" do
          expect(Idea.find(idea1.id).description).to eq("changed")
        end

        it "flashes success message" do
          expect(flash[:success]).to be_present
        end

        it "renders create" do
          expect(response).to render_template "update"
        end

        it "sets @ideas" do
          expect(assigns(:ideas).count).to eq(3)
        end

        it "adds categories to idea" do
          expect(assigns(:idea).categories.count).to eq(2)
        end
      end

      context "valid input categories empty" do
        before do
          patch :update, idea: {name: idea1.name, description: "changed", category_ids: [""] }, id: idea1.id, format: 'js'
        end

        it "categories to idea" do
          expect(assigns(:idea).categories.count).to eq(1)
        end
      end

      context "invalid input" do
        before do
          patch :update, idea: {name: nil, description: "changed" }, id: idea1.id, format: 'js'
        end

        it "doesn't update idea" do
          expect(Idea.find(idea1.id).name).to eq(idea1.name)
        end

        it "flashes danger" do
          expect(flash[:danger]).to be_present
        end

        it "renders edit" do
          expect(response).to render_template "edit"
        end
      end
    end
  end
  describe "POST update_status" do
    let!(:user1) { Fabricate(:user) }
    let!(:idea1) { Fabricate(:idea, user_id: user1.id, status: "Hold") }
    before { sign_in user1 }
    context "status changed" do
      before do
        post :update_status, id: idea1.id, status: "Active", format: 'js'
      end

      it "updates status of idea" do
        expect(assigns(:idea).status).to eq("Active")
      end

      it "expects flash success to be present" do
        expect(flash[:success]).to be_present
      end

      it "renders show" do
        expect(response).to render_template 'show'
      end

      it "set @notable" do
        expect(assigns(:notable)).to eq(idea1)
      end
    end

    context "status not changed" do
      before do
        post :update_status, id: idea1.id, status: "Hold", format: 'js'
      end

      it "does not updates status of idea" do
        expect(assigns(:idea).status).to eq("Hold")
      end

      it "expects flash success to be present" do
        expect(flash[:success]).to be_nil
      end

      it "renders show" do
        expect(response).to render_template 'show'
      end

      it "set @notable" do
        expect(assigns(:notable)).to eq(idea1)
      end
    end
  end
  describe "POST remove_category" do
    let!(:user1) { Fabricate(:user) }
    let!(:cat1) { Fabricate(:category, user_id: user1.id) }
    let!(:cat2) { Fabricate(:category, user_id: user1.id) }
    (1..3).each do |i|
      let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
    end

    before do
      sign_in user1
      idea1.categories << [cat1, cat2]
      post :remove_category, id: idea1.id, category_id: cat1.id, format: 'js'
    end

    it "removes category from idea" do
      expect(assigns(:idea).categories.count).to eq(1)
    end

    it "renders category links from idea" do
      expect(response).to render_template 'remove_category'
    end

    it "should flash success" do
      expect(flash[:success]).to be_present
    end
  end

  describe "DELETE destroy" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
      let!("idea#{i}".to_sym) { Fabricate(:idea, name: "idea_name#{i}", user_id: user1.id) }
    end
    let!(:note1) { Fabricate(:note, user_id: user1.id) }
    let!(:note2) { Fabricate(:note, user_id: user1.id) }
    let!(:task1) { Fabricate(:task, user_id: user1.id) }
    let!(:task2) { Fabricate(:task, user_id: user1.id) }
    
    before do 
      sign_in user1
      idea1.notes << [note1, note2]
      idea1.tasks << [task1, task2]
      delete :destroy, id: idea1.id, format: 'js'
    end

    it "finds correct idea and set @idea" do
      expect(assigns(:idea)).to eq(idea1)
    end

    it "should remove idea" do
      expect(Idea.all.count).to eq(2)
    end

    it "sets flash success" do
      expect(flash[:success]).to be_present
    end

    it "renders destroy" do
      expect(response).to render_template("destroy")
    end
  end

  describe "GET move_up" do
    let(:user1) { Fabricate(:user) }
    
    context "idea is not top" do

      before(:example) do

        sign_in user1
        
        (1..6).each do |i|
          status = ["Active", "Hold"]
          si = i%2
          Fabricate(:idea, name: "idea#{i}", status: status[si], user_id: user1.id)
        end
        
        xhr :get, :move_up, id: Idea.where(name: "idea2").first.id, format: 'js'
      end

      it "finds correct idea and sets @idea" do
        expect(assigns(:idea).name).to eq("idea2")
      end

      it "move idea2 to postion 1" do
        expect(Idea.where(name: "idea2").first.position).to eq(1)
      end

      it "at itentifies next" do
        expect(assigns(:next_idea).name).to eq("idea1")
      end

      it "moved idea1 down to spot 2" do
        expect(Idea.where(name: "idea1").first.position).to eq(2)
      end

      it "flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "idea is top" do
      before(:example) do

        sign_in user1
        
        (1..6).each do |i|
          status = ["Active", "Hold"]
          si = i%2
          Fabricate(:idea, name: "idea#{i}", status: status[si], user_id: user1.id)
        end
        
        xhr :get, :move_up, id: Idea.where(name: "idea1").first.id, format: 'js'
      end

      it "finds correct idea and sets @idea" do
        expect(assigns(:idea).name).to eq("idea1")
      end

      it "move idea1 staus at postion 1" do
        expect(Idea.where(name: "idea1").first.position).to eq(1)
      end

      it "flash failure" do
        expect(flash[:danger]).to be_present
      end
      it "renders nothing" do
        expect(response.body).to be_blank
      end
    end
  end

  describe "GET move_down" do
    let(:user1) { Fabricate(:user) }
    
    context "idea is not bottom" do

      before(:example) do

        sign_in user1
        
        (1..6).each do |i|
          status = ["Active", "Hold"]
          si = i%2
          Fabricate(:idea, name: "idea#{i}", status: status[si], user_id: user1.id)
        end
        
        xhr :get, :move_down, id: Idea.where(name: "idea2").first.id, format: 'js'
      end

      it "finds correct idea and sets @idea" do
        expect(assigns(:idea).name).to eq("idea2")
      end

      it "move idea2 to postion 3" do
        expect(Idea.where(name: "idea2").first.position).to eq(3)
      end

      it "at itentifies next" do
        expect(assigns(:next_idea).name).to eq("idea3")
      end

      it "moved idea3 upto to spot 2" do
        expect(Idea.where(name: "idea3").first.position).to eq(2)
      end

      it "flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "idea is bottom" do
      before(:example) do

        sign_in user1
        
        (1..6).each do |i|
          status = ["Active", "Hold"]
          si = i%2
          Fabricate(:idea, name: "idea#{i}", status: status[si], user_id: user1.id)
        end
        
        xhr :get, :move_down, id: Idea.where(name: "idea6").first.id, format: 'js'
      end

      it "finds correct idea and sets @idea" do
        expect(assigns(:idea).name).to eq("idea6")
      end

      it "move idea1 staus at postion 1" do
        expect(Idea.where(name: "idea6").first.position).to eq(6)
      end

      it "flash failure" do
        expect(flash[:danger]).to be_present
      end
      it "renders nothing" do
        expect(response.body).to be_blank
      end
    end
  end
end
