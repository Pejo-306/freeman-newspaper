require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @non_admin = users(:michael)
    @topic = topics(:sample_topic)
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

  test 'should not get edit when not logged in' do
    get edit_topic_path(@topic)
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not get edit when logged in as a non-admin' do
    log_in_as @non_admin
    get edit_topic_path(@topic)
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get edit when logged in as an admin' do
    log_in_as @admin
    get edit_topic_path(@topic)
    assert_response :success
    assert_template 'topics/edit'
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

  test 'should not update topic when not logged in' do
    name = @topic.name
    travel 1.hours do
      assert_no_changes '@topic.reload.updated_at' do
        patch topic_path(@topic), params: { topic: { name: 'invalid' } }
      end
    end
    @topic.reload
    assert_equal name, @topic.name
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update topic when logged in as a non-admin' do
    log_in_as @non_admin
    name = @topic.name
    travel 1.hours do
      assert_no_changes '@topic.reload.updated_at' do
        patch topic_path(@topic), params: { topic: { name: 'invalid' } }
      end
    end
    @topic.reload
    assert_equal name, @topic.name
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not update topic when invalid information is posted' do
    log_in_as @admin
    name = @topic.name
    travel 1.hours do
      assert_no_changes '@topic.reload.updated_at' do
        patch topic_path(@topic), params: { topic: { name: '' } }
      end
    end
    @topic.reload
    assert_equal name, @topic.name
    assert_template 'topics/edit'
  end

  test 'should update topic when valid information is posted' do
    log_in_as @admin
    travel 1.hours do
      assert_changes '@topic.reload.updated_at' do
        patch topic_path(@topic), params: { topic: { name: 'valid' } }
      end
    end
    @topic.reload
    assert_equal 'valid', @topic.name
    assert_response :redirect
    assert_redirected_to topic_path(@topic)
  end

  test 'should not delete topic when not logged in' do
    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should not delete topic when logged in as an admin' do
    log_in_as @non_admin
    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should delete topic when logged in as an admin' do
    log_in_as @admin
    assert_difference 'Topic.count', -1 do
      delete topic_path(@topic)
    end
    assert_response :redirect
    assert_redirected_to topics_path
  end
end

