require 'test_helper'

class Admin::UserModelCreationTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    log_in_as @admin
  end

  test 'unsuccessful user creation' do
    get new_admin_user_path
    assert_response :success
    assert_template 'new'
    assert_select 'form[action="/admin/users"]'
    assert_no_difference 'User.count' do
      post admin_users_path, params: { user: { name: '',
                                               surname: '',
                                               email: 'email@invalid',
                                               password: 'wrong', 
                                               password_confirmation: 'invalid',
                                               activated: false,
                                               admin: false } }
    end
    assert_template 'new'
    assert_select 'form[action="/admin/users"]'
    assert_select '#error-explanation > p', text: 'The form contains 5 errors:'
    assert_select '#error-explanation > ul' do 
      assert_select 'li', count: 5
    end
  end

  test 'successful user creation' do
    get new_admin_user_path
    assert_response :success
    assert_template 'new'
    assert_select 'form[action="/admin/users"]'
    assert_nil User.find_by_name('Albert')
    assert_difference 'User.count', 1 do
      post admin_users_path, params: { user: { name: 'Albert',
                                               surname: 'Einstein',
                                               email: 'genius@example.com',
                                               password: 'password',
                                               password_confirmation: 'password',
                                               activated: false,
                                               admin: false } }
    end
    user = User.find_by_name('Albert')
    assert user
    assert_response :redirect
    assert_redirected_to admin_user_path(user)
    follow_redirect!
    assert_template 'show'
    assert_not flash.empty?
    assert_equal 'User has been created', flash[:success] 
    assert_select 'h1', text: 'User: Albert Einstein'
    assert_select 'p#name', text: 'name: Albert'
    assert_select 'p#surname', text: 'surname: Einstein'
    assert_select 'p#email', text: 'email: genius@example.com' 
    assert_select 'p#activated', text: 'activated: false'
    assert_select 'p#admin', text: 'admin: false'
    assert_select 'p#activated_at', text: 'activated_at: <null>'
    assert_select 'span#created_at', text: "#{Time.zone.now}"
    assert_select 'span#updated_at', text: "#{Time.zone.now}"
  end
end

