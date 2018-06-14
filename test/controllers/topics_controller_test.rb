require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :michael
    @topic = topics :sample_topic

    @topic_exists = -> (name) { URI.encode "/topics/exists/#{name}" }
  end

  test 'should get index' do
    get topics_path
    assert_response :success
    assert_template 'topics/index'
  end

  test 'should paginate topics' do
    get topics_path
    assert_select 'main nav.pagination', count: 1
    first_page_of_topics = Topic.paginate page: 1, per_page: 6
    assert_select '#topics-list' do
      assert_select '.topic-holder', 6
    end
    first_page_of_topics.each do |topic|
      assert_select 'h3.topic-name', text: topic.name
      assert_select 'a.topic-link[href=?]', topic_path(topic.name)
    end
  end

  test 'should get show' do
    get topic_path(@topic.name)
    assert_response :success
    assert_template 'topics/show'
  end

  test 'should paginate articles on topic show page' do
    get topic_path(@topic.name)
    assert_select 'main nav.pagination', count: 1
    first_page_of_articles = Article.joins(:topics).where('topic_id = ?', @topic.id)
                             .paginate(page: 1, per_page: 10)
                             .order('updated_at DESC')
    assert_select '#articles-list' do
      assert_select 'li', 10
    end
    first_page_of_articles.each do |article|
      assert_select 'a[href=?]', article_path(article)
      assert_select 'span', text: article.title
      assert_select 'p', text: article.content
      assert_select 'img[src=?]', article.thumbnail.url if article.thumbnail?
      assert_includes article.topics, @topic
    end
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

