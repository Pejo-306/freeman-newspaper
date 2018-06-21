require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_path 
    assert_response :success
    assert_template 'home'
  end

  test 'should display some randomly selected topics' do
    get root_path
    assert_select '#topics-list' do
      assert_select '.topic-holder', count: 8
    end
    assert_select 'a[href=?]', topics_path, text: 'More topics'
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_template 'about'
  end
end

