class CategoriesController < ApplicationController
	before_filter :authenticate_user!
  respond_to :js, :html
  before_action  :all_categories, only: [:index, :create, :update, :destroy]
  before_action :set_category, only: [:edit, :update, :show ]
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        flash[:success] = "You have created a new category: #{@category.name}"
        format.html { redirect_to categories_path }
        format.js { render action: 'create' }
      else
        flash[:danger] = "There is a problem, try again."
        format.html { render nothing: true }
        format.js { render action: 'edit' }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        flash[:success] = "#{@category.name} category updated."
        format.html { redirect_to categories_path }
        format.js { render action: 'create' }
      else
        flash[:danger] = "Something when wrong."
        #format.html { render 'edit' }
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
    category = current_user.categories.friendly.find(params[:id])
    name = category.name
    category.destroy
    respond_to do |format|
      flash[:success] = "You have removed category: #{name}."
      format.js { render action: 'destroy'} 
      #format.html { redirect_to categories_path }
    end
  end

  def show
    @notes = @category.notes
    @note = Note.new
    @note.user_id = current_user.id
    @notable = @category
    @ideas = @category.ideas
  end
  
  private

    def set_category
      @category = current_user.categories.friendly.find(params[:id])
    end

    def all_categories
      @categories = current_user.categories
    end

    def category_params
      params.require(:category).permit(:name, :description, :user_id, :slug)
    end
end
