require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'should get new' do
    get login_path 
    assert_response :success
    assert_template 'sessions/new'
  end

  test 'should not log in user when invalid data is submitted' do
    failing_cases = [ { email: '', password: '' },
                      { email: @user.email, password: 'wrong_pass' }, 
                      { email: '', password: 'password' } ]
    failing_cases.each do |args|
      post login_path, params: { session: { email: args[:email],
                                            password: args[:password] } }
      assert_not logged_in?
    end
  end

  test 'should log in user when valid data is submitted' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert logged_in?
  end

  test 'should log out user' do
    log_in_as @user
    delete logout_path
    assert_not logged_in?
  end
end

