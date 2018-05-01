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

  test 'should not create a new topic as an anonymous user' do
    assert_no_difference 'Topic.count' do
      post topics_path, params: { topic: { name: 'Unique topic' } }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not create a new topic as a non-admin user' do
    log_in_as @non_admin
    assert_no_difference 'Topic.count' do
      post topics_path, params: { topic: { name: 'Unique topic' } }
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should create a new topic when valid information is posted' do
    log_in_as @admin
    assert_difference 'Topic.count', 1 do
      post topics_path, params: { topic: { name: 'Unique topic' } }
    end
    assert_response :redirect
    assert_redirected_to topics_path
  end

  test 'should not create a new topic when invalid information is posted' do
    log_in_as @admin
    assert_no_difference 'Topic.count' do
      post topics_path, params: { topic: { name: '' } }
    end
    assert_template 'topics/new'
  end
end

