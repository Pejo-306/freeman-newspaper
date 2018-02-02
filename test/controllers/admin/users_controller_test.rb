require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'should get index' do
    get admin_users_path
    assert_response :success
    assert_template 'index'
  end

  test 'should paginate users' do
    get admin_users_path
    assert_select 'div.pagination', count: 2
  end

  test 'should get show' do
    get admin_user_path(@user)
    assert_response :success
    assert_template 'show'
  end

  test 'should display user information' do
    get admin_user_path(@user)
    assert_select 'h1', text: @user.full_name
    assert_select 'p#name', text: "name: #{@user.name}"
    assert_select 'p#surname', text: "surname: #{@user.surname}"
    assert_select 'p#email', text: "email: #{@user.email}"
    assert_select 'p#created_at', text: "created_at: #{@user.created_at}"
    assert_select 'p#updated_at', text: "updated_at: #{@user.updated_at}"
    assert_select 'p#admin', text: "admin: #{@user.admin}"
    assert_select 'p#activated', text: "activated: #{@user.activated}"
    assert_select 'p#activated_at', text: "activated_at: #{@user.activated_at}"
  end

  test 'should get new' do
    get new_admin_user_path
    assert_response :success
    assert_template 'new'
  end

  test 'should render a form for user creation' do
    get new_admin_user_path
    assert_select 'form[action="/admin/users"]'
  end

  test 'should get edit' do
    get edit_admin_user_path(@user)
    assert_response :success
    assert_template 'edit'
    assert_not flash.empty?
    warning_msg = 'WARNING: be very careful when altering field values'
    assert_equal warning_msg, flash.now[:warning]
  end
  
  test 'should not create a user with invalid input data' do
    assert_no_difference 'User.count' do
      post admin_users_path, params: { user: { name: '',
                                               surname: '',
                                               email: 'email@invalid', 
                                               password: '',
                                               password_confirmation: '',
                                               activated: false, 
                                               admin: false } }
    end
    assert_template 'new'
  end

  test 'should create a user with valid input data' do
    assert_difference 'User.count', 1 do
      post admin_users_path, params: { user: { name: 'Albert',
                                               surname: 'Einstein',
                                               email: 'genius@example.com', 
                                               password: 'password',
                                               password_confirmation: 'password',
                                               activated: false, 
                                               admin: true } }
    end
    assert_response :redirect 
    assert_not flash.empty?
    assert_equal 'User has been created', flash[:success]
  end

  test 'should not update user with invalid input data' do
    travel 1.hours # ensure last time updated is not now
    assert_no_changes '@user.reload.updated_at' do
      patch admin_user_path(@user), params: {
        user: { name: '',
                surname: '',
                email: 'email@invalid',
                password: '',
                password_confirmation: '',
                activated: false,
                admin: false }
      }
    end
    assert_template 'edit'
  end

  test 'should update user with valid input data' do
    travel 1.hours # ensure last time updated is not now
    assert_changes '@user.reload.updated_at' do
      patch admin_user_path(@user), params: {
        user: { name: 'Matt',
                surname: @user.surname,
                email: @user.email,
                password: '',
                password_confirmation: '',
                activated: @user.activated,
                admin: @user.admin }
      }
    end
    assert_response :redirect
    assert_redirected_to admin_user_path(@user)
    assert_not flash.empty?
    assert_equal 'User has successfully been updated', flash[:success]
  end

  test 'should destroy user' do
    assert_difference 'User.count', -1 do
      delete admin_user_path(@user)
    end
    assert_response :redirect
    assert_redirected_to admin_users_path
    assert_not flash.empty?
    assert_equal 'User has successfully been deleted', flash[:success]
  end
end

