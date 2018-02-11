require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test 'signup with invalid data' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', surname: '', 
                                          email: 'user@invalid',
                                          password:              'short',
                                          password_confirmation: 'long' } }
    end
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_select '#error-explanation p', 'The form contains 5 errors:' 
  end

  test 'signup with valid data and activate account' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                          email: 'genius@example.com',
                                          password:              'password',
                                          password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_equal 'Please check your email to activate your account.', flash[:info]
    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activation
    log_in_as user
    assert_not logged_in?
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    warning_message = 'Account not activated. ' \
                      'Check your email for the activation link.'
    assert_equal warning_message, flash[:warning]

    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    assert_equal 'Invalid activation link', flash[:danger]

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'invalid')
    assert_not logged_in?
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    assert_equal 'Invalid activation link', flash[:danger]

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
    assert_not flash.empty?
    assert_equal 'Account activated!', flash[:success]
  end
end

