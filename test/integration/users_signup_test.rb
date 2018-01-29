require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'singup page layout' do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
  end

  test 'invalid signup data' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', surname: '', 
                                          email: 'user@invalid',
                                          password:              'short',
                                          password_confirmation: 'long' } }
    end
    assert_template 'users/new'
    assert_select 'div#error-explanation div.alert', 'The form contains 5 errors.' 
  end

  test 'valid signup data' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Example', surname: 'User',
                                          email: 'user@example.com',
                                          password:              'password',
                                          password_confirmation: 'password' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_equal flash[:success], 'Your account has successfully been created.'
  end
end

