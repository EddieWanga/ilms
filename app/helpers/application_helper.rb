module ApplicationHelper
  def notice_message
    alert_types = { notice: :success, alert: :danger }
 
    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)
 
    alerts = flash.map do |type, message|
      alert_content = close_button + message
 
      alert_type = alert_types[type.to_sym] || type
      alert_class = "alert alert-#{alert_type} alert-dismissable"
 
      content_tag(:div, alert_content, class: alert_class)
    end
 
    alerts.join("\n").html_safe
  end
  
  def is_admin?(user)
    if !current_user
      return false
    else 
      return user.role == 0
    end
  end

  def is_reviewed?(answer)
    return answer.review != nil
  end

  def get_time(time, current_time)
    if current_time > time
      content_tag(:font, "#{time.to_s.split(' ')[0..1].join(' ')}(已過期)", color: "red")
    else
      content_tag(:font, time.to_s.split(' ')[0..1].join(' '))
    end  
  end
  
  def submit_time(time, current_time)
    if current_time > time
      content_tag(:font, "#{current_time.to_s.split(' ')[0..1].join(' ')}(已過期)", color: "red")
    else
      content_tag(:font, current_time.to_s.split(' ')[0..1].join(' '))
    end  
  end

  def can_submit_homework?(user, homework)
    if is_admin?(user)
      return false
    elsif user.district == nil
      return true
    elsif user.district == homework.district
      return true
    else
      return false
    end
  end
end
