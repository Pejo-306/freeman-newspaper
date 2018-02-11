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

  # Return the Bootstrap 4 css classes needed to style a form label
  def label_classes(*extra_classes)
    bootstrap_classes = ['col-sm-2', 'col-form-label']
    css_classes = [*bootstrap_classes, *extra_classes]
    css_classes.join(' ')
  end

  # Return the Bootstrap 4 css classes needed to style a form submit button 
  def submit_classes(*extra_classes)
    bootstrap_classes = ['btn', 'btn-block']
    css_classes = [*bootstrap_classes, *extra_classes]
    css_classes.join(' ')
  end
end

