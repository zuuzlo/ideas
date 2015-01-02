class TasksController < ApplicationController
  before_action :authenticate_user!
  respond_to :js, :html
  before_action :load_taskable, only: [:new, :create, :edit, :update ]
  before_action :set_task, only: [:edit, :update]
  def new
    @task = Task.new 
    @task.user_id = current_user.id
  end

  def create
    @task = @taskable.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "You created a new task."
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def edit

  end

  def update
    if @task.update(task_params)
      flash[:success] = "Successfully updated task."
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end

  end

  private
    def set_task
      @task = Task.friendly.find(params[:id])
    end

    def load_taskable

      if params[:idea_id]
        @taskable = Idea.friendly.find(params[:idea_id])
      end
    end

    def task_params
      params.require(:task).permit(:id, :name, :description, :assigned_by, :assigned_to, :user_id, :percent_complete, :start_date, :finish_date, :completion_date, :status, :slug, :idea_id)
    end

end
