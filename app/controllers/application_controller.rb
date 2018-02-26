class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include WebDesignHelper

  protect_from_forgery with: :exception
end

