require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  setup do
    @article = articles :sample_article
    @topic = topics :sample_topic
    @other_topic = topics :art_topic
  end

  test 'should be valid' do
    assert @topic.valid?
  end

  test 'name should be present' do
    assert @topic.valid?
    @topic.name = ''
    assert_not @topic.valid?
  end

  test 'name should be unique' do
    assert @topic.valid?
    @topic.name = @other_topic.name
    assert_not @topic.valid?
  end

  test 'db should enforce a uniqueness constraint on name' do
    assert_not_equal @topic.name, @other_topic.name
    assert_raises ActiveRecord::RecordNotUnique do
      # NOTE: validation is skipped when updating
      @topic.update_attribute :name, @other_topic.name
    end
    assert_not_equal @topic.reload.name, @other_topic.name
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

