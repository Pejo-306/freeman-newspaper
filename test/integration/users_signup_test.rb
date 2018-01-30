require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    assert_select 'div#error-explanation div.alert', 'The form contains 5 errors.' 
  end

  test 'signup with valid data' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                          email: 'genius@example.com',
                                          password:              'password',
                                          password_confirmation: 'password' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
    assert_not flash.empty?
    assert_equal 'Your account has successfully been created.', flash[:success]
  end
end

