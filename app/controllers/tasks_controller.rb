class TasksController < ApplicationController
  include LoadChildren
  before_action :authenticate_user!
  respond_to :js, :html
  before_action :load_taskable, only: [:move_down, :move_up, :new, :create, :edit, :update, :destroy, :update_task, :more_less ]
  before_action :set_task, only: [:move_down, :move_up, :show_children, :destroy, :edit, :update, :update_task, :more_less]
  
  def new
    @task = Task.new 
    @task.user_id = current_user.id
  end

  def show
    @parent = Task.find(params[:id])
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
    respond_to do |format|
      if @task.update(task_params)
        format.html {@parent = @task; load_children(@parent); flash[:success] = "Successfully updated task."; render :show }
        format.js 
        flash[:success] = "Successfully updated task."
      else
        flash[:danger] = "Something went wrong, try again."
        render :edit
      end
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
    
    if @@tab == "All"
      fail = @task.first?
    
    else
      status = @task.status
      next_same_status = @task.higher_items.where(status: status).last
      @task_position = @task.position

      if next_same_status
        next_position = next_same_status.position 
        
        if @task_position - next_position  > 1
          @above_task = @task.higher_item
        else
          @above_task = @task
        end

        fail = false
      else
        fail = true
      end
    end
    
    if fail
      flash[:danger] = "Task is already at the top."
      render nothing: true
    else
      case @@tab
      when "All"
        @task.move_higher
        @next = @task.lower_item
        @above_task = @task
      else
        @next = next_same_status
        @next.set_list_position(@task_position)
        @task.insert_at(next_position)
      end
      flash[:success] = "Task moved up list."
    end
  end

  def move_down

    if @@tab == "All"
      fail = @task.last?
    
    else
      status = @task.status
      next_same_status = @task.lower_items.where(status: status).first
      @task_position = @task.position

      if next_same_status
        next_position = next_same_status.position 
        
        if next_position - @task_position > 1
          @above_task = @task.lower_item
        else
          @above_task = @task
        end

        fail = false
      else
        fail = true
      end
    end
    
    if fail
      flash[:danger] = "Task is already at the bottom."
      render nothing: true
    else
      case @@tab
      when "All"
        @task.move_lower
        @next = @task.higher_item
        @above_task = @task
      else
        @next = next_same_status
        @next.set_list_position(@task_position)
        @task.insert_at(next_position)
      end
      flash[:success] = "Task moved up list."
    end
  end

  def tab_all
    @@tab = "All"
  end

  def tab_active
    @@tab = "Active"
  end

  def tab_hold
    @@tab = "Hold"
  end

  def tab_complete
    @@tab = "Complete"
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def load_taskable

      if params[:idea_id]
        @taskable = Idea.friendly.find(params[:idea_id])
      elsif params[:task_id]
        @taskable = Task.find(params[:task_id])
      end
    end

    def task_params
      params.require(:task).permit(:id, :name, :description, :assigned_by, :assigned_to, :user_id, :percent_complete, :start_date, :finish_date, :completion_date, :status, :slug, :idea_id, :task_id)
    end

end
