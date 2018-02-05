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

  # Return a copyright notice year range
  # or the first year of the copyright
  # when it is less than a year old
  def copyright_notice_year_range(start_year)
    current_year = Time.zone.now.year
    if current_year > start_year
      "#{start_year} - #{current_year}"
    else
      "#{start_year}"
    end
  end
end

