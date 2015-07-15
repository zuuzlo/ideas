require 'rails_helper'

RSpec.describe IdeaLinksController, :type => :controller do
  describe "GET new" do
    context "unauthenticated user" do
      let(:user1) { Fabricate(:user) }
      let(:idea1) { Fabricate(:idea, user_id: user1.id) }
      
      it_behaves_like "require_sign_in" do
        let(:action) { get :new, idea_id: idea1.id }
      end
    end

    context "authenticated user" do
      let(:user1) { Fabricate(:user) }
      let(:idea1) { Fabricate(:idea, user_id: user1.id) }

      before do
        sign_in user1
        xhr :get, :new, idea_id: idea1.id, format: 'js'
      end

      it "sets @idea_link to instance of IdeaLink" do
        expect(assigns(:idea_link)).to be_a IdeaLink
      end

      it "sets @idea_link.user_id to current user" do
        expect(assigns(:idea_link).user_id).to eq(user1.id)
      end

      it "renders new" do
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    before { sign_in user1 }
    
    context "valid input" do
      before do
        post :create, idea_link: { name: "New Link", link_url: 'http://google.com', user_id: user1.id }, idea_id: idea1.id, format: 'js'
      end

      it "loads @idea_linkable" do
        expect(assigns(:idea_linkable)).to eq(idea1)
      end

      it "creates a new task" do
        expect(IdeaLink.all.count).to eq(1)
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
        post :create, idea_link: { name: "New Link", link_url: 'google', user_id: user1.id }, idea_id: idea1.id, format: 'js'
      end

      it "it does not creates a new idea_link" do
        expect(IdeaLink.all.count).to eq(0)
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
    let(:idea_link1) { Fabricate(:idea_link, user_id: user1.id) }
      
    before do
      idea1.idea_links << idea_link1
      sign_in user1
      xhr :get, :edit, id: idea_link1.id, idea_id: idea1.id, format: 'js'
    end

    it "sets @idea_link and finds proper idea_link1" do
      expect(assigns(:idea_link)).to eq(idea_link1)
    end

    it "renders edit" do
      expect(response).to render_template :edit
    end

    it "sets @taskable to proper idea" do
      expect(assigns(:idea_linkable)).to eq(idea1)
    end
  end

  describe "PATCH update" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:idea_link1) { Fabricate(:idea_link, user_id: user1.id) }
      
    before do
      idea1.idea_links << idea_link1
      sign_in user1
    end

    context "valid input" do
      before do
        patch :update, idea_link: { name: "Edit Link", link_url: "https://google.com"  },id: idea_link1.id, idea_id: idea1.id, format: 'js'
      end

      it "sets @idea_link and finds proper idea_link" do
        expect(assigns(:idea_link)).to eq(idea_link1)
      end

      it "sets @taskable to proper idea" do
        expect(assigns(:idea_linkable)).to eq(idea1)
      end

      it "renders create" do
        expect(response).to render_template :update
      end

      it "updates the link" do
        expect(assigns(:idea_link).name).to eq("Edit Link")
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "invalid input" do
      before do
        patch :update, idea_link: { name: "Edit Link", link_url: "google.com"  },id: idea_link1.id, idea_id: idea1.id, format: 'js'
      end

      it "sets @idea_link and finds proper idea_link" do
        expect(assigns(:idea_link)).to eq(idea_link1)
      end

      it "sets @taskable to proper idea" do
        expect(assigns(:idea_linkable)).to eq(idea1)
      end

      it "renders edit" do
        expect(response).to render_template :edit
      end

      it "task is not updated" do
        expect(IdeaLink.find(idea_link1.id).name).to eq(idea_link1.name)
      end

      it "sets flash success" do
        expect(flash[:danger]).to be_present
      end
    end
  end

  describe "DELETE destroy" do
    let(:user1) { Fabricate(:user) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:idea_link1) { Fabricate(:idea_link, user_id: user1.id) }
    let(:idea_link2) { Fabricate(:idea_link, user_id: user1.id) }

    before do
      idea1.idea_links << [idea_link1, idea_link2]
      sign_in user1
      delete :destroy, id: idea_link1.id, idea_id: idea1.id, format: 'js'
    end

    it "finds correct task to delete and sets @task" do
      expect(assigns(:idea_link)).to eq(idea_link1)
    end

    it "loads notable parent of the note." do
      expect(assigns(:idea_linkable)).to eq(idea1)
    end

    it "sets flash success" do
      expect(flash[:success]).to be_present
    end

    it "removes the record" do
      expect(IdeaLink.all.count).to eq(1)
    end

    it "renders destroy" do
      expect(response).to render_template("destroy")
    end
  end
end
