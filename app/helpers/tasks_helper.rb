module TasksHelper
  def taskable_link(type, id)
    taskable_path = type.constantize.find(id)
    link_to "Link to Parent", taskable_path
  end

  def tasks_percent_complete_total(tasks)
    if tasks.count != 0
      sum_percent_complete = 0
      
      tasks.each do |task|
        sum_percent_complete += task.percent_complete
      end

      (sum_percent_complete / tasks.count).to_i
    else
      0
    end
  end
  
  def row_class_task(task)
    case task.status
    when "Hold"
      return "row-warning"
    when "Complete"
      return "row-info"
    else
      return "row-success"
    end
  end
end
