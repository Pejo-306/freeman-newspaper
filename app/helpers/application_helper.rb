module ApplicationHelper
  def require_login
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end

  def require_admin_status
    unless current_user.admin?
      store_location
      flash[:danger] = 'The account you have logged into ' +  
                       'does not have admin privileges'
      redirect_to login_url
    end
  end

  def require_anonymity
    if logged_in?
      flash[:danger] = 'You must log out to view this page'
      redirect_to root_url
    end
  end

  def current_year
    Time.zone.now.year
  end

  # Provide the difference in time between two dates
  def time_diff(from_date, to_date, format: 'seconds')
    timedelta = (from_date - to_date).to_i.abs
    timedelta /=
    case format
    when 'seconds' then 1.0
    when 'minutes' then 60.0
    when 'hours' then 3600.0
    when 'days' then 86400.0
    end
  end

  # Provide the title of a page
  def site_title(page_title = '', base_title: "The Freeman's newspaper")
    if !request.nil? && request.original_fullpath['admin']
      base_title = "Admin | #{base_title}" 
    end

    return base_title if page_title.blank?
    "#{page_title} | #{base_title}"
  end

  # Get a form field type from an attribute name
  def get_form_field_type(attribute_type)
    case attribute_type
    when :string, 'string' then 'text_field'
    when :integer, 'integer' then 'number_field'
    end
  end
end

