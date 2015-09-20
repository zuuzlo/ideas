class TasksController < ApplicationController
  include LoadChildren
  before_action :authenticate_user!
  respond_to :js, :html
  before_action :load_taskable, only: [:new, :create, :edit, :update, :destroy, :update_task, :more_less ]
  before_action :set_task, only: [:move_up, :show_children, :destroy, :edit, :update, :update_task, :more_less]
  
  def new
    @task = Task.new 
    @task.user_id = current_user.id
  end

  def show
    @parent = Task.friendly.find(params[:id])
    load_children(@parent)
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

  def update
    if @task.update(task_params)
      flash[:success] = "Successfully updated task."
    else
      flash[:danger] = "Something went wrong, try again."
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = "Task removed."
    else
      flash[:danger] = "Failed to remove task."
    end
  end

  def update_task
    if params[:percent_complete] == 100 || params[:status] == "Complete"
      percent_complete = 100
      status = "Complete"
      completion_date = Time.now
      finish_date = params[:finish_date]
    else 
      percent_complete = params[:percent_complete]
      status = params[:status]
      completion_date = params[:completion_date]
      finish_date = params[:finish_date]
    end

    if @task.update(percent_complete: percent_complete, status: status, completion_date: completion_date, finish_date: finish_date)
      flash[:success] = "You successfully updated a task"
    else
      flash[:danger] = "Something went wrong, try again."
    end
  end

  def more_less

  end

  def show_children

  end

  def move_up
    @status = @task.status
    taskable = @task.taskable_type.constantize.friendly.find(@task.taskable_id)
    active_order = taskable.tasks.where(["status = :status", { status: @status } ])
    order = []
    
    active_order.each do |task|
      order << task.position
    end

    place = order.index(@task.position)
    @order_diff = (order[place] - order[place - 1]) unless place == 0
    
    if @task.higher_item.nil? || @order_diff.nil?
      require 'pry'; binding.pry
      render :nothing => true
    else
      #@above_task = @task.higher_item
      #@task.move_higher
    end
  end

  private
    def set_task
      @task = Task.friendly.find(params[:id])
    end

    def load_taskable

      if params[:idea_id]
        @taskable = Idea.friendly.find(params[:idea_id])
      elsif params[:task_id]
        @taskable = Task.friendly.find(params[:task_id])
      end
    end

    def task_params
      params.require(:task).permit(:id, :name, :description, :assigned_by, :assigned_to, :user_id, :percent_complete, :start_date, :finish_date, :completion_date, :status, :slug, :idea_id, :task_id)
    end

end
