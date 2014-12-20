class CategoriesController < ApplicationController
	before_filter :authenticate_user!

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "You have created a new category: #{@category.name}"
      redirect_to categories_path
    else
      flash[:danger] = "There is a problem, try again."
      render 'new'
    end
  end

  def index
    @categories = Category.all
  end
  
  private

  def category_params
    params.require(:category).permit(:name, :descripton, :user_id)
  end
end
