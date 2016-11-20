class IdeasController < ApplicationController
  include LoadChildren
  before_action :authenticate_user!
  respond_to :js, :html
  before_action :all_ideas, only: [:index, :create, :update]
  before_action :set_idea, only: [:destroy, :edit, :update, :show, :update_status, :remove_category, :move_up, :move_down]
  

  def new
    @idea = Idea.new
  end

  def show
    load_children(@idea)
=begin
    @notes = @idea.notes
    @tasks = @idea.tasks
    @idea_links = @idea.idea_links
    @note = Note.new
    @task = Task.new
    @idea_link = IdeaLink.new
    #@note.user_id = current_user.id
    @notable = @idea
    @taskable = @idea
    @idea_linkable = @idea
=end
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

  def destroy
    if @idea.destroy
      flash[:success] = "Idea removed."
    else
      flash[:danger] = "Failed to remove idea."
    end  
  end

  def update_status
    status = params[:status]
    old_status = @idea.status
    
    unless status == old_status
      @idea.update(status: status)
      flash[:success] = "Updated idea status."
    end
    @taskable = @idea
    @notable = @idea
    @idea_linkable = @idea
    render :show
  end

  def remove_category
    @idea.categories.destroy(params[:category_id])
    flash[:success] = "Removed category from idea"
  end

  def move_up

    if @idea.first?
      flash[:danger] = "Idea is already at the top."
      render nothing: true
    else
      @idea.move_higher
      @next_idea = @idea.lower_item
      flash[:success] = "Idea moved up the list."
    end
  end

  def move_down
    if @idea.last?
      flash[:danger] = "Idea is already at the bottom."
      render nothing: true
    else
      @idea.move_lower
      @next_idea = @idea.higher_item
      flash[:success] = "Idea moved down the list."
    end

  end

  private
    def set_idea
      @idea = current_user.ideas.friendly.find(params[:id])
    end

    def all_ideas
      @ideas = current_user.ideas
    end

    def idea_params
      params.require(:idea).permit(:name, :description, :benefits, :problem_solves, :user_id, :slug, :status, :category_ids, :id)
    end
end
