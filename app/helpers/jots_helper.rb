module JotsHelper

  def row_class(jot)
    case jot.status
    when "Hold"
      return "warning"
    when "Complete"
      return "info"
    else
      return "success"
    end
  end
end
