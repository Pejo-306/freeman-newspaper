require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin) # admin user
    @other_user = users(:michael) # non-admin user
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get index when logged in' do
    log_in_as @admin
    get users_path
    assert_response :success
    assert_template 'users/index'
  end

  test 'should display only activated users on index page' do
    @other_user.update_attribute(:activated, false)
    log_in_as @admin
    get users_path
    assert_select 'a', text: @other_user.full_name, count: 0
  end

  test 'should get show' do
    get user_path(@admin)
    assert_response :success
    assert_template 'users/show'
  end

  test 'should redirect show page for inactivated account' do
    @other_user.update_attribute(:activated, false)
    get user_path(@other_user)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should get new' do
    get signup_path 
    assert_response :success
    assert_template 'users/new'
  end

  test 'should get edit when user is logged in' do
    log_in_as @admin
    get edit_user_path(@admin)
    assert_response :success
    assert_template 'users/edit'
  end

  test 'should redirect edit when user is not logged in' do
    get edit_user_path(@admin)
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'should redirect update when user is not logged in' do
    patch user_path(@admin), params: { user: { name: @admin.name,
                                              surname: @admin.surname,
                                              email: @admin.email } }
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
    assert_equal @admin, @admin.reload # user has not been changed
  end

  test 'should redirect edit when logged in as the wrong user' do
    log_in_as @other_user
    get edit_user_path(@admin)
    assert flash.empty?
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as the wrong user' do
    log_in_as @other_user
    patch user_path(@admin), params: { user: { name: @admin.name,
                                              surname: @admin.surname,
                                              email: @admin.email } }
    assert flash.empty?
    assert_response :redirect
    assert_redirected_to root_url
    assert_equal @admin, @admin.reload # user has not been changed
  end

  test 'should create a new user when valid information is posted' do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                          email: 'genius@example.com',
                                          password:              'password',
                                          password_confirmation: 'password', } }
    end
    assert_response :redirect
  end

  test 'should not create a new user when invalid information is posted' do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', surname: '',
                                          email: 'email@invalid',
                                          password:              'short',
                                          password_confirmaiton: 'long' } }
    end
    assert_template 'users/new'
  end

  test 'should not update user when invalid information is posted' do
    log_in_as @admin
    patch user_path(@admin), params: { user: { name: '', surname: '',
                                              email: '',
                                              password: 'wrong',
                                              password_confirmation: 'pass' } }
    assert_equal @admin, @admin.reload
  end

  test 'should update user when valid information is posted' do
    log_in_as @admin
    name = 'Albert'
    surname = 'Einstein'
    patch user_path(@admin), params: { user: { name: name, surname: surname } }
    @admin.reload
    assert_equal name, @admin.name
    assert_equal surname, @admin.surname
  end

  test 'should not allow the user to edit the admin attribute' do
    log_in_as @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { admin: true } }
    assert_not @other_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end
end

