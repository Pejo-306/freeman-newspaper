require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path 
    assert_response :success
    assert_template 'home'
  end

  test 'should display a number of articles' do
    get root_path
    assert_select '#all-articles' do
      assert_select 'li', count: 8
    end
  end

  test 'should display some randomly selected topics' do
    get root_path
    assert_select '#topics-list' do
      assert_select '.topic-holder', count: 8
    end
    assert_select 'a[href=?]', topics_path, text: 'More topics'
  end

  test 'should display a number of columns' do
    get root_path
    assert_select '#columns-list' do
      assert_select '.column-container', count: 8
    end
    assert_select 'a[href=?]', columns_path
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_template 'about'
  end
end

