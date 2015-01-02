class IdeasController < ApplicationController
  before_action :authenticate_user!
  before_action :all_ideas, only: [:index, :create, :update, :destroy]
  before_action :set_idea, only: [:edit, :update, :show, :update_status, :remove_category]
  respond_to :js, :html

  def new
    @idea = Idea.new
  end

  def show
    @notes = @idea.notes
    @tasks = @idea.tasks
    @note = Note.new
    @task = Task.new
    @note.user_id = current_user.id
    @notable = @idea
    @taskable = @idea
  end

  def create
    
    @idea = Idea.new(idea_params)
    if @idea.save
      flash[:success] = "You created a new idea. Good luck."
      category_ids = params[:idea][:category_ids].reject{ |a| a=="" }
      @idea.categories << Category.friendly.find(category_ids) unless category_ids.empty?
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def update

    if @idea.update(idea_params)
      flash[:success] = "#{@idea.name} idea updated."
      category_ids = params[:idea][:category_ids].reject{ |a| a=="" }
      @idea.categories << Category.friendly.find(category_ids) unless category_ids.empty?
      render :update
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def update_status
    status = params[:status]
    old_status = @idea.status
    
    unless status == old_status
      @idea.update(status: status)
      flash[:success] = "Updated idea status."
    end

    @notable = @idea
    render :show
  end

  def remove_category
    @idea.categories.destroy(params[:category_id])
    flash[:success] = "Removed category from idea"
  end

  private
    def set_idea
      @idea = current_user.ideas.friendly.find(params[:id])
    end

    def all_ideas
      @ideas = current_user.ideas
    end

    def idea_params
      params.require(:idea).permit(:name, :description, :benefits, :problem_solves, :user_id, :slug, :status, :category_ids)
    end
end
