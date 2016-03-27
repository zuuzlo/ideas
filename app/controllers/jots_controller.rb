class JotsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js, :html
  
  def new
    @jot = Jot.new
  end

  def index
    @jots = current_user.jots
  end

  def create
    @jot = Jot.new(jot_params)

    if @jot.save
      @jot.move_to_top
      flash[:success] = "You created a new Jot. Good luck!"
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
    
    @jots = current_user.jots
  end

  def edit
    @jot = current_user.jots.find(params[:id])
  end

  def update
    @jot = current_user.jots.find(params[:id])
    @jots = current_user.jots

    if @jot.update(jot_params)
      flash[:success] = "Jot #{@jot.position} idea updated."
      render :update
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def destroy
    @jot = current_user.jots.find(params[:id])

    if @jot.destroy
      flash[:success] = "Jot removed."

    else
      flash[:danger] = "Failed to remove jot."
    end  
  end

  def to_new_idea
    @jot = current_user.jots.find(params[:id])
    @idea = current_user.ideas.create(name: @jot.context, description: @jot.context, status: "Hold")
    
    if @idea.save
      flash[:success] = "Idea created from Jot."
      render :js => "window.location.href='"+ideas_path+"'"
      #redirect_to ideas_path
    else
      flash[:danger] = "Something went wrong, try again."
      render nothing: true
    end
  end

  def to_new_task

    @jot = current_user.jots.find(params[:id])
    @parent = current_user.ideas.find(params[:idea_id])
    @task = Task.create(user_id: current_user.id, name: @jot.context, status: "Hold", taskable_type: "Idea", taskable_id: @parent.id)
    #@parent.tasks << Task.create(user_id: current_user.id, name: @jot.context, status: "Hold")
    if @task.save
      flash[:success] = "Task created from Jot."
      render :js => "window.location.href='"+task_path(@task)+"'"
      #redirect_to task_path(@task)
    else
      flash[:danger] = "Something went wrong, try again."
    end
  end

  def move_up
    @jot = current_user.jots.find(params[:id])
    
    if @jot.first?
      flash[:danger] = "Jot is already at the top."
      render nothing: true
    else
      @jot.move_higher
      @next_jot = @jot.lower_item
      flash[:success] = "Jot moved up list."
    end
  end

  def move_down
    @jot = current_user.jots.find(params[:id])
    if @jot.last?
      flash[:danger] = "Jot is already at the bottom."
      render nothing: true
    else
      @jot.move_lower
      @next_jot = @jot.higher_item
      flash[:success] = "Jot moved down list."
    end
  end

  private

  def jot_params
    params.require(:jot).permit(:context, :status, :user_id, :id)
  end
end
