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

  test 'should get show' do
    get admin_user_path(@user)
    assert_response :success
    assert_template 'show'
  end

  test 'should display user information' do
    # Ensure the user has digests set 
    @user.remember
    @user.create_reset_digest
    @user.update_column(:activation_digest, User.digest(User.new_token))

    get admin_user_path(@user)
    assert_select 'h1', text: @user.full_name
    assert_select 'p#name', text: "name: #{@user.name}"
    assert_select 'p#surname', text: "surname: #{@user.surname}"
    assert_select 'p#email', text: "email: #{@user.email}"
    assert_select 'p#created_at', text: "created_at: #{@user.created_at}"
    assert_select 'p#updated_at', text: "updated_at: #{@user.updated_at}"
    assert_select 'p#password_digest',
                  text: "password_digest: #{@user.password_digest}"
    assert_select 'p#remember_digest',
                  text: "remember_digest: #{@user.remember_digest}"
    assert_select 'p#admin', text: "admin: #{@user.admin}"
    assert_select 'p#activation_digest',
                  text: "activation_digest: #{@user.activation_digest}"
    assert_select 'p#activated', text: "activated: #{@user.activated}"
    assert_select 'p#activated_at', text: "activated_at: #{@user.activated_at}"
    assert_select 'p#reset_digest', text: "reset_digest: #{@user.reset_digest}"
    assert_select 'p#reset_sent_at',
                  text: "reset_sent_at: #{@user.reset_sent_at}"
  end
end

