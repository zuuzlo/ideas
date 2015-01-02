module ApplicationHelper
  
  def bootstrap_flash_type(name)
    case name
    when "error", "danger"
      "danger"
    when "alert"
      "info"
    when "success"
      "success"
    when "notice"
      "warning"
    end
  end
end
