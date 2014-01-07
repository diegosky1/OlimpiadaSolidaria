module ApplicationHelper
  ALERT_TYPES = [:danger, :info, :success, :warning]
  

  def bootstrap_flash
    output = ''
    flash.each do |type, message|
      next if message.blank?
      type = :success if type == :notice
      type = :danger   if type == :alert
      next unless ALERT_TYPES.include?(type)
      output += flash_container(type, message)
    end

    raw(output)
  end

  def render_backend_nav(user)
    if user.master?
      render partial: 'master/shared/nav'
    elsif user.admin?
      render partial: 'admin/shared/nav'
    elsif user.student?
      render partial: 'users/shared/nav'
    end
  end

  def password_placeholder(user)
    user.new_record? ? 'Password' : '(sin modificar)'
  end

  def date_slash_format(date)
    date.strftime("%d/%m/%Y")
  end

  def date_with_short_month(date)
    date.strftime("%d %b %Y")
  end

  def flash_container(type, message)
    raw(content_tag(:div, :class => "alert alert-#{type}") do
      content_tag(:a, raw("&times;"),:class => 'close', :data => {:dismiss => 'alert'}) +
      message.html_safe
    end)
  end

end
