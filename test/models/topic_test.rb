require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  setup do
    @article = articles(:sample_article)
    @topic = topics(:sample_topic)
  end

  test 'should be valid' do
    assert @topic.valid?
  end

  test 'name should be present' do
    assert @topic.valid?
    @topic.name = ''
    assert_not @topic.valid?
  end

  test 'name should not be longer than 100 characters' do
    @topic.name = 'a' * 100
    assert @topic.valid?
    @topic.name += 'a'
    assert_not @topic.valid?
  end

  test 'should be associated to articles' do
    assert_includes @topic.articles, @article
  end
end

