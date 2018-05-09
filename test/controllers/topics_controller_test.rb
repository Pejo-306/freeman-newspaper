require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :michael
    @topic = topics :sample_topic
    @topic_exists = -> (name) { URI.encode "/topics/exists/#{name}" }
  end

  test 'should not get exists as an anonymous user' do
    get @topic_exists.call @topic.name 
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should confirm the existence of a topic' do
    log_in_as @user
    get @topic_exists.call @topic.name
    assert_response :success
    output = JSON.parse @response.body
    assert output['exists']
  end

  test 'should confirm the absence of a topic' do
    log_in_as @user
    get @topic_exists.call 'non-existent topic' 
    assert_response :success
    output = JSON.parse @response.body
    assert_not output['exists']
  end
end

