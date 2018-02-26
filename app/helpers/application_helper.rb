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

  def current_year
    Time.zone.now.year
  end

  # Provide the title of a page
  def site_title(page_title = '', base_title: "The Freeman's newspaper")
    return base_title if page_title.blank?
    "#{base_title} | #{page_title}"
  end
end

