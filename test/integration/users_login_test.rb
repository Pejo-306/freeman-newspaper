require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'login with invalid data' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid data and then logout' do
    # Log in
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # Log out
    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_url
    follow_redirect!
  end
end

