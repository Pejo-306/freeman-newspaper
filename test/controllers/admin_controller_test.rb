require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_path
    assert_response :success
    assert_template 'admin/index'
  end

  test 'should display models' do
    get admin_path
    assert_template 'admin/index'
    assert_select 'a[href=?]', admin_users_path, text: 'Users'
  end
end

