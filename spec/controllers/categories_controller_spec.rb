require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
  describe "GET new" do
    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) {get :new}
      end
    end
  end

  context "authenticated user" do
    let(:user1) { Fabricate(:user) }
    before do
      sign_in user1
    end

    it "sets @category as an instance of Category" do
      get :new
      expect(assigns(:category)).to be_a Category
    end
  end

  describe "POST create" do
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
        let(:user1) { Fabricate(:user) }
        let(:category1) { Fabricate(:category, name: "Work", user_id: user1.id) }
        
        before do
          sign_in user1
          post :create, category: { name: 'Work', description: 'ideas around work', user_id: user1.id }
        end

        it "doesn't save record" do
          expect(Category.count).to eq(1)
        end

        it "renders new" do
          expect(response).to render_template :new
        end

        it "flashes danger message" do
          expect(flash[:danger]).to be_present
        end
      end
    end
  end
end