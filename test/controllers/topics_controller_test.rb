require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @non_admin = users(:michael)
  end

  test 'should not get new when not logged in' do
    get new_topic_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not get new when logged in as a non-admin' do
    log_in_as @non_admin
    get new_topic_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get new when logged in as an admin' do
    log_in_as @admin
    get new_topic_path
    assert_response :success
    assert_template 'topics/new'
  end
end

