module AuthorsHelper
  def require_author_status
    unless current_user.author?
      store_location
      flash[:danger] = 'The account you have logged in ' +
                       'does not have author status'
      redirect_to login_url
    end
  end

  # Return the current logged-in author (if any)
  def current_author
    Author.find(current_user.id) unless current_user.nil?
  end
end

