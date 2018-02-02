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
end

