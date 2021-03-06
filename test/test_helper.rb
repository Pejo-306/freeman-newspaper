require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Log in as user
  def log_in_as(user)
    session[:user_id] = user.id
  end

  # Return true if the user is logged in
  def logged_in?
    !session[:user_id].nil?
  end

  # Clear all ActionMailer deliveries
  def clear_deliveries
    ActionMailer::Base.deliveries.clear
  end
end

class ActionDispatch::IntegrationTest
  # Log in as a user
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end

