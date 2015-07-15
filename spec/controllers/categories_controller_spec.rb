require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
  describe "GET new" do
    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) {get :new}
      end
    end
  
    context "authenticated user" do
      let(:user1) { Fabricate(:user) }
      before do
        sign_in user1
      end

      it "sets @category as an instance of Category" do
        xhr :get, :new
        expect(assigns(:category)).to be_a Category
      end
    end
  end

  describe "POST create" do
    render_views
    context "authorized user" do
      context "valid input" do
        let(:user1) { Fabricate(:user) }
        before do
          sign_in user1
          post :create, category: { name: 'Work', description: 'ideas around work', user_id: user1.id }
        end
        it "@category is an instance of Category" do
          expect(assigns(:category)).to be_a Category
        end

        it "save new category" do
          expect(Category.count).to eq(1)
        end

        it "flashes success message" do
          expect(flash[:success]).to be_present
        end

        it "redircts to Categories index" do
          expect(response).to redirect_to categories_path
        end
      end
      context "invalid input" do
        let!(:user1) { Fabricate(:user) }
        
        before do
          Fabricate(:category, name: "Work", user_id: user1.id)
          sign_in user1
          post :create, category: { name: 'Work', description: 'ideas around work', user_id: user1.id }, format: 'js'
        end

        it "doesn't save record" do
          expect(Category.count).to eq(1)
        end

        it "response to be successful" do
          expect(response).to be_success
        end

        it "flashes danger message" do
          expect(flash[:danger]).to be_present
        end
      end
    end
  end

  describe "GET edit" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    
    before do
      sign_in user1
      xhr :get, :edit, id: cat1.id, format: 'js'
    end

    it "sets @category to category to be edited" do
      expect(assigns(:category)).to eq(cat1)
    end

    it "renders edit" do
      expect(response).to render_template :edit
    end
  end

  describe "PUT update" do
    context "valid input on edit" do
      let(:user1) { Fabricate(:user) }
      let(:cat1) { Fabricate(:category, user_id: user1.id) }
      
      before do
        sign_in user1
        put :update, category: {name: cat1.name, description: "changed"}, id: cat1.id
      end

      it "sets @category to category being edited" do
        expect(assigns(:category)).to eq(cat1)
      end

      it "set flash success" do
        expect(flash[:success]).to be_present
      end

      it "updates category" do
        expect(Category.first.description).to eq("changed")
      end

      it "redirect_to categories_path" do
        expect(response).to redirect_to categories_path
      end
    end

    context "invalid input" do
      let(:user1) { Fabricate(:user) }
      let(:cat1) { Fabricate(:category, user_id: user1.id) }
      
      before do
        sign_in user1
        put :update, category: {name: nil, description: "changed"}, id: cat1.id, format: 'js'
      end

      it "sets @category to category being edited" do
        expect(assigns(:category)).to eq(cat1)
      end

      it "set flash danger" do
        expect(flash[:danger]).to be_present
      end

      it "doesn't change category" do
        expect(Category.first.description).to eq(cat1.description)
      end

      it "redirect_to categories_path" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
      
    before do
      sign_in user1
      xhr :get, :destroy, id: cat1.id, format: 'js'
    end

    it "deletes cat1" do
      expect(Category.all.count).to eq(0)
    end

    it "flashes success" do
      expect(flash[:success]).to be_present
    end

    it "response to be success" do
      expect(response).to be_success
    end
  end

  describe "GET show" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    let(:note1) { Fabricate(:note, user_id: user1.id) }
    let(:note2) { Fabricate(:note, user_id: user1.id) }
    let(:idea1) { Fabricate(:idea, user_id: user1.id) }
    let(:idea2) { Fabricate(:idea, user_id: user1.id) }
      
    before do
      sign_in user1
      cat1.notes << note1
      cat1.notes << note2
      idea1.categories << cat1
      idea2.categories << cat1
      get :show, id: cat1.id
    end

    it "sets @category" do
      expect(assigns(:category)).to eq(cat1)
    end
    
    it "sets @notes" do
      expect(assigns(:category).notes).to match_array([note2, note1])
    end

    it "sets @note" do
      expect(assigns(:note)).to be_a Note
    end

    it "sets @note user_id to current user" do
      expect(assigns(:note).user_id).to eq(user1.id)
    end

    it "sets @notable to @category" do
      expect(assigns(:notable)).to eq(cat1)
    end

    it "sets @ideas" do
      expect(assigns(:ideas)).to match_array([idea1, idea2])
    end
  end

  describe "GET index" do
    let(:user1) { Fabricate(:user) }
    let(:cat1) { Fabricate(:category, user_id: user1.id) }
    let(:cat2) { Fabricate(:category, user_id: user1.id) }
      
    before do
      sign_in user1
      get :index
    end

    it "sets @categories with all users categories" do
      expect(assigns(:categories)).to eq([cat2,cat1])
    end
  end
end