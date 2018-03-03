require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
  end

  test 'should require admin status' do
    get admin_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get index' do
    log_in_as @admin
    get admin_path
    assert_response :success
    assert_template 'admin/index'
  end

  test 'should display models' do
    log_in_as @admin
    get admin_path
    assert_template 'admin/index'
    assert_select 'a[href=?]', admin_users_path, text: 'Users'
  end
end

