class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include WebDesignHelper
  include AuthorsHelper
  include ColumnsHelper
  include ArticleHelper

  protect_from_forgery with: :exception
end

