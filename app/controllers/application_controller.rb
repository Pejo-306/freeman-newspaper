class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include WebDesignHelper
  include AuthorsHelper

  protect_from_forgery with: :exception
end

