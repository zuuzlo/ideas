require 'rails_helper'

RSpec.describe JotsController, :type => :controller do
  describe "GET new" do
    let!(:user1) { Fabricate(:user) }

    before do
      sign_in user1
      xhr :get, :new
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @jot to instance of Jot" do
      expect(assigns(:jot)).to be_a Jot
    end

    it "renders new" do
      expect(response).to render_template :new
    end
  end

  describe "GET index" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
      let!("jot#{i}".to_sym) { Fabricate(:jot, context: "context#{i}", user_id: user1.id) }
    end

    before do
      sign_in user1
      get :index
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @jots to all users jots" do
      expect(assigns(:jots).count).to eq(3)
    end
  end

  describe "POST create" do
    context "authorized user" do
      let!(:user1) { Fabricate(:user) }
      (1..3).each do |i|
        let!("jot#{i}".to_sym) { Fabricate(:jot, context: "context#{i}", user_id: user1.id) }
      end
      before { sign_in user1 }

      context "valid input" do
        before do
          post :create, jot: Fabricate.attributes_for(:jot, user_id: user1.id, context: "jot context"), format: 'js'
        end
        
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "@jot is an instance of Jot" do
          expect(assigns(:jot)).to be_a Jot
        end

        it "creates a new idea" do
          expect(Jot.count).to eq(4)
        end

        it "flashes success message" do
          expect(flash[:success]).to be_present
        end

        it "renders create" do
          expect(response).to render_template "create"
        end

        it "sets @Jots" do
          expect(assigns(:jots).count).to eq(4)
        end

        it "set new jot position to 1" do
          expect(assigns(:jot).position).to eq(1)
        end

      end

      context "invalid input" do
        before do
          post :create, jot: Fabricate.attributes_for(:jot, user_id: user1.id, context: ''), format: 'js'
        end

        it "doesn't create a new jot" do
          expect(Jot.count).to eq(3)
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

  describe "GET edit" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
        let!("jot#{i}".to_sym) { Fabricate(:jot, context: "jot_name#{i}", user_id: user1.id) }
    end
    before do 
      sign_in user1
      xhr :get, :edit, id: jot1.id, format: 'js'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets @jot to jot to be edited" do
      expect(assigns(:jot)).to eq(jot1)
    end

    it "renders edit" do
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do
    context "authorized user" do
      let!(:user1) { Fabricate(:user) }
      (1..3).each do |i|
        let!("jot#{i}".to_sym) { Fabricate(:jot, context: "jot_name#{i}", user_id: user1.id) }
      end

      before do
        sign_in user1
      end

      context "valid input" do
        before do
          patch :update, jot: { context: "changed" }, id: jot1.id, format: 'js'
        end
        
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "@jot find jot to be updated" do
          expect(assigns(:jot)).to eq(jot1)
        end

        it "updates idea" do
          expect(Jot.find(jot1.id).context).to eq("changed")
        end

        it "flashes success message" do
          expect(flash[:success]).to be_present
        end

        it "renders create" do
          expect(response).to render_template "update"
        end

        it "sets @jots" do
          expect(assigns(:jots).count).to eq(3)
        end
      end

      context "invalid input" do
        before do
          patch :update, jot: {context: "" }, id: jot1.id, format: 'js'
        end

        it "doesn't update idea" do
          expect(Jot.find(jot1.id).context).to eq(jot1.context)
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

  describe "DELETE destroy" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
      let!("jot#{i}".to_sym) { Fabricate(:jot, context: "jot_name#{i}", user_id: user1.id) }
    end

    before do
      sign_in user1
      delete :destroy, id: jot1.id, format: 'js'
    end

    it "finds correct jot and set @jot" do
      expect(assigns(:jot)).to eq(jot1)
    end

    it "should remove idea" do
      expect(Jot.all.count).to eq(2)
    end

    it "sets flash success" do
      expect(flash[:success]).to be_present
    end

    it "renders destroy" do
      expect(response).to render_template("destroy")
    end
  end

  describe "GET move_up" do
    let!(:user1) { Fabricate(:user) }
    
    context "jot is in middle not at top" do
     
      before(:example) do
        sign_in user1
        (1..3).each do |i|
          Fabricate(:jot, context: "jot_#{i}", user_id: user1.id)
        end
        xhr :get, :move_up, id: Jot.where(context: "jot_2").first.id, format: 'js'
      end

      it "finds correct jot and set @jot" do
        expect(assigns(:jot).context).to eq("jot_2")
      end

      it "move jot2 up to top" do
        expect(Jot.where(context: "jot_2").first.first?).to be true
      end

      it "moved jot1 down to spot 2" do
        expect(Jot.where(context: "jot_1").first.position).to eq(2)
      end

      it "flash success" do
        expect(flash[:success]).to be_present
      end
    end
    context "jot is in top position" do
      before(:example) do
        sign_in user1
        (1..3).each do |i|
          Fabricate(:jot, context: "jot_#{i}", user_id: user1.id)
        end
        xhr :get, :move_up, id: Jot.first.id, format: 'js'
      end

      it "finds correct jot and set @jot" do
        expect(assigns(:jot).context).to eq("jot_1")
      end

      it "flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "renders nothing" do
        expect(response.body).to be_blank
      end
    end
  end

  describe "GET move_down" do
    let!(:user1) { Fabricate(:user) }
    
    context "jot is in middle not at top" do
     
      before(:example) do
        sign_in user1
        (1..3).each do |i|
          Fabricate(:jot, context: "jot_#{i}", user_id: user1.id)
        end
        xhr :get, :move_down, id: Jot.where(context: "jot_2").first.id, format: 'js'
      end

      it "finds correct jot and set @jot" do
        expect(assigns(:jot).context).to eq("jot_2")
      end

      it "move jot2 up to top" do
        expect(Jot.where(context: "jot_2").first.last?).to be true
      end

      it "moved jot1 down to spot 2" do
        expect(Jot.where(context: "jot_3").first.position).to eq(2)
      end

      it "flash success" do
        expect(flash[:success]).to be_present
      end
    end
    context "jot is bottom position" do
      before(:example) do
        sign_in user1
        (1..3).each do |i|
          Fabricate(:jot, context: "jot_#{i}", user_id: user1.id)
        end
        xhr :get, :move_down, id: Jot.last.id, format: 'js'
      end

      it "finds correct jot and set @jot" do
        expect(assigns(:jot).context).to eq("jot_3")
      end

      it "flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "renders nothing" do
        expect(response.body).to be_blank
      end
    end
  end

  describe "GET to_new_idea" do
    let!(:user1) { Fabricate(:user) }
    (1..3).each do |i|
      let!("jot#{i}".to_sym) { Fabricate(:jot, context: "jot_name#{i}", user_id: user1.id) }
    end

    before do
      sign_in user1
      xhr :get, :to_new_idea, id: jot1.id, format: 'js'
    end
    
    it "assigns jot" do
      expect(assigns(:jot)).to eq (jot1)
    end

    it "assigns idea" do
      expect(assigns(:idea).description).to eq(jot1.context)
    end

    it "redirects to create idea" do
      expect(response).to redirect_to @ideas
    end
  end

  describe "POST to_new_task" do
    let!(:user1) { Fabricate(:user) }
    let!(:idea1) { Fabricate(:idea, user_id: user1.id) }
    
    (1..3).each do |i|
      let!("jot#{i}".to_sym) { Fabricate(:jot, context: "jot_name#{i}", user_id: user1.id) }
    end

    before(:example) do
      sign_in user1
      post :to_new_task, idea_id: idea1.id, id: jot1.id, format: 'js'
    end

    it "assigns idea" do
      expect(assigns(:idea)).to eq(idea1)
    end

    it "assigns jot" do
      expect(assigns(:jot)).to eq(jot1)
    end

    it "adds new task to idea1" do
      expect(assigns(:idea).tasks.count).to eq(1)
    end

    it "task name to equal jot context" do
      expect(assigns(:idea).tasks.first.name).to eq(jot1.context)
    end

    it "redirects to create idea" do
      expect(response).to redirect_to idea_path(:idea1)
    end
  end
end
