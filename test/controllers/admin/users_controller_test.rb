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
    # Ensure user has all field filled
    @user.remember
    @user.create_reset_digest
    @user.update_column(:activation_digest, User.digest(User.new_token))

    get admin_user_path(@user)
    assert_select 'h1', text: @user.full_name
    assert_select 'p#id', text: "id: #{@user.id}"
    assert_select 'p#name', text: "name: #{@user.name}"
    assert_select 'p#surname', text: "surname: #{@user.surname}"
    assert_select 'p#email', text: "email: #{@user.email}"
    assert_select 'p#created_at', text: "created_at: #{@user.created_at}"
    assert_select 'p#updated_at', text: "updated_at: #{@user.updated_at}"
    assert_select 'p#password_digest',
                   text: "password_digest: #{@user.password_digest}"
    assert_select 'p#admin', text: "admin: #{@user.admin}"
    assert_select 'p#activation_digest',
                   text: "activation_digest: #{@user.activation_digest}"
    assert_select 'p#activated', text: "activated: #{@user.activated}"
    assert_select 'p#activated_at', text: "activated_at: #{@user.activated_at}"
    assert_select 'p#reset_digest', text: "reset_digest: #{@user.reset_digest}"
    assert_select 'p#reset_sent_at', text: "reset_sent_at: #{@user.reset_sent_at}"
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
    assert_equal warning_msg, flash[:warning]
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
end

