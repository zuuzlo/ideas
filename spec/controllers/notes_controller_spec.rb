require 'rails_helper'

RSpec.describe NotesController, :type => :controller do
  describe "POST create" do
    context "unauthenticated user" do
      let(:user1) { Fabricate(:user) }
      let(:cat1) { Fabricate(:category, user_id: user1.id) }
      
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, note: { }, category_id: cat1.id }
      end
    end
  
    context "authenticated user" do
      context "valid input js out" do
        let(:user1) { Fabricate(:user) }
        let(:cat1) { Fabricate(:category, user_id: user1.id) }
        before do
          sign_in user1
          post :create, note: { title:'new note', text: 'this is a new note', user_id: user1.id }, category_id: cat1.id, format: 'js'
        end

        it "sets @note is a Note" do
          expect(assigns(:note)).to be_a Note
        end

        it "creates a new note" do
          expect(Note.all.count).to eq(1)
        end

        it "sets flash success" do
          expect(flash[:success]).to be_present
        end

        it "renders action create" do
          expect(response).to render_template("create")
        end
      end

      context "valid input html out" do
        let(:user1) { Fabricate(:user) }
        let(:cat1) { Fabricate(:category, user_id: user1.id) }
        before do
          sign_in user1
          post :create, note: { title:'new note', text: 'this is a new note', user_id: user1.id }, category_id: cat1.id
        end

        it "renders action show" do
          expect(response).to redirect_to category_path(cat1)
        end
      end

      context "not valid input js out" do
        let(:user1) { Fabricate(:user) }
        let(:cat1) { Fabricate(:category, user_id: user1.id) }

        before do
          sign_in user1
          post :create, note: { title: nil, text: 'this is a new note', user_id: user1.id }, category_id: cat1.id, format: 'js'
        end

        it "sets flash danger" do
          expect(flash[:danger]).to be_present
        end

        it "doesn't create a new note" do
          expect(Note.all.count).to eq(0)
        end

        it "renders edit" do
          expect(response).to render_template("edit")
        end
      end
    end
  end

  describe "GET new" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    
    before do
      sign_in user1
      xhr :get, :new, category_id: cat1.id, format: 'js'
    end

    it "sets @note to instance of Note" do
      expect(assigns(:note)).to be_a Note
    end

    it "sets @note.user_id to current_user.id" do
      expect(assigns(:note).user_id).to eq(user1.id)
    end

    it "loads notable parent of the note." do
      expect(assigns(:notable)).to eq(cat1)
    end

    it "renders new" do
      expect(response).to render_template("new")
    end
  end

  describe "GET edit" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    let(:note1) { Fabricate(:note, user_id: user1.id) }
    
    before do
      sign_in user1
      cat1.notes << note1
      xhr :get, :edit, id: note1.id, category_id: cat1.id, format: 'js'
    end

    it "sets @note to find note" do
      expect(assigns(:note)).to eq(note1)
    end

    it "loads notable parent of the note." do
      expect(assigns(:notable)).to eq(cat1)
    end

    it "renders edit" do
      expect(response).to render_template("edit")
    end
  end

  describe "PATCH update" do
    context "valid input" do
      let(:user1) { Fabricate(:user) }
      let(:cat1) { Fabricate(:category, user_id: user1.id) }
      let(:note1) { Fabricate(:note, user_id: user1.id) }
      before do
        sign_in user1
        cat1.notes << note1
        patch :update, note: { title:'new note', text: 'this is a new note', user_id: user1.id }, id: note1.id, category_id: cat1.id, format: 'js'
      end

      it "sets @note to find note" do
        expect(assigns(:note)).to eq(note1)
      end

      it "loads notable parent of the note." do
        expect(assigns(:notable)).to eq(cat1)
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end

      it "renders action create" do
        expect(response).to render_template("update")
      end
    end

    context "invalid input" do
      let(:user1) { Fabricate(:user) }
      let(:cat1) { Fabricate(:category, user_id: user1.id) }
      let(:note1) { Fabricate(:note, user_id: user1.id) }
      
      before do
        sign_in user1
        cat1.notes << note1
        patch :update, note: { title: nil, text: 'this is a new note', user_id: user1.id }, id: note1.id, category_id: cat1.id, format: 'js'
      end

      it "sets flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "renders edit" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    let(:note1) { Fabricate(:note, user_id: user1.id) }
    
    before do
      sign_in user1
      cat1.notes << note1
      delete :destroy, id: note1.id, category_id: cat1.id, format: 'js'
    end

    it "sets @note to find note" do
      expect(assigns(:note)).to eq(note1)
    end

    it "loads notable parent of the note." do
      expect(assigns(:notable)).to eq(cat1)
    end

    it "sets flash success" do
      expect(flash[:success]).to be_present
    end

    it "removes the record" do
      expect(Note.all.count).to eq(0)
    end

    it "renders destroy" do
      expect(response).to render_template("delete")
    end
  end

  describe "GET show" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    let(:note1) { Fabricate(:note, user_id: user1.id) }
    
    before do
      sign_in user1
      cat1.notes << note1
      get :show, id: note1.id, category_id: cat1.id
    end

    it "set @note" do
      expect(assigns(:note)).to eq(note1)
    end

    it "sets @notable" do
      expect(assigns(:notable)).to eq(note1)
    end
  end
end