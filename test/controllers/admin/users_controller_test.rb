require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get admin_users_path
    assert_response :success
    assert_template 'admin/users/index'
  end
end

