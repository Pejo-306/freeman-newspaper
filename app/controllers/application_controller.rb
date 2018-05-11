class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include WebDesignHelper
  include AuthorsHelper
  include ColumnsHelper

  protect_from_forgery with: :exception
end

