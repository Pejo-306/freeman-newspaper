require 'test_helper'

class Admin::TopicsControllerTest < ActionDispatch::IntegrationTest
  # NOTE: your users fixtures file must include a fixture whose name is
  #       'admin'; said fixture must have admin privileges 
  # NOTE: your model fixtures file must include a fixture whose name is
  #       'sample_<record_name>' (e.g. 'sample_book', 'sample_user', etc.)
  #       as well as more than 20 (depends on pagination test) other samples
  # NOTE: your model must provide a method named 'display' or whatever you
  #       passed as a display method name when generating the admin:model_manager
  # NOTE: Please, manually complete the record creation and update tests

  setup do
    @admin = users(:admin)
    log_in_as @admin
    
    @sample_topic = topics(:sample_topic)
  end

  test 'should get index' do
    get admin_topics_path
    assert_response :success
    assert_template 'index'
  end

  test 'should paginate topics' do
    get admin_topics_path
    assert_select 'main nav.pagination', count: 2
    first_page_of_topics = Topic.paginate(page: 1, per_page: 20)
    assert_select 'ul#pagination-items' do
      assert_select 'li', 20
    end
    first_page_of_topics.each do |topic|
      assert_select 'a[href=?]',
                    admin_topic_path(topic),
                    text: topic.display
      assert_select 'a[href=?]',
                    edit_admin_topic_path(topic),
                    text: 'edit'
      assert_select 'a[href=?][data-method="delete"]',
                    admin_topic_path(topic),
                    text: 'delete'
    end
  end

  test 'should get show' do
    get admin_topic_path(@sample_topic)
    assert_response :success
    assert_template 'show'
  end

  test 'should link back to index page on show' do
    get admin_topic_path(@sample_topic)
    assert_select 'a[href=?]', admin_topics_path, text: 'Back to index page'
  end 

  test 'should link to edit page on show' do
    get admin_topic_path(@sample_topic)
    assert_select 'a[href=?]', edit_admin_topic_path(@sample_topic), text: 'Edit'
  end

  test 'should display topic information' do
    get admin_topic_path(@sample_topic)
    assert_select 'span#created_at', text: "#{@sample_topic.created_at}"
    assert_select 'span#updated_at', text: "#{@sample_topic.updated_at}"
    assert_select 'h1', text: "Topic: #{@sample_topic.display}"
    
    assert_select "p#name", text: "name: #{@sample_topic.name}"
    
  end

  test 'should get new' do
    get new_admin_topic_path
    assert_response :success
    assert_template 'new'
  end

  test 'should link to new on index page' do
    get admin_topics_path
    assert_response :success
    assert_template 'index'
    assert_select 'a[href=?]', new_admin_topic_path, text: 'New topic'
  end

  test 'should render a form for topic creation' do
    get new_admin_topic_path
    assert_select 'form[action="/admin/topics"]'
  end

  test 'should link back to index page on new' do
    get new_admin_topic_path
    assert_select 'a[href=?]', admin_topics_path, text: 'Back to index page'
  end 

  test 'should get edit' do
    get edit_admin_topic_path(@sample_topic)
    assert_response :success
    assert_template 'edit'
    assert_not flash.empty?
    warning_msg = 'WARNING: be very careful when altering field values'
    assert_equal warning_msg, flash.now[:warning]
  end
  
  test 'should link back to index page on edit' do
    get edit_admin_topic_path(@sample_topic)
    assert_select 'a[href=?]', admin_topics_path, text: 'Back to index page'
  end 

  test 'should link to show page on edit' do
    get edit_admin_topic_path(@sample_topic)
    assert_select 'a[href=?]', admin_topic_path(@sample_topic), text: 'View information'
  end

  test 'should not create a topic with invalid input data' do
    assert_no_difference 'Topic.count' do
      post admin_topics_path, params: {
        topic: {
          # TODO: add invalid input data here
          name: ''
        }
      }
    end
    assert_template 'new'
  end

  test 'should create a user with valid input data' do
    assert_difference 'Topic.count', 1 do
      post admin_topics_path, params: {
        topic: {
          # TODO: add valid input data here
          name: 'something very unique'
        }
      }
    end
    assert_response :redirect 
    assert_not flash.empty?
    assert_equal 'Topic has been created', flash[:success]
  end

  test 'should not update user with invalid input data' do
    travel 1.hours # ensure last time updated is not now
    assert_no_changes '@sample_topic.reload.updated_at' do
      patch admin_topic_path(@sample_topic), params: {
        topic: {
          # TODO: add invalid input data here
          name: ''
        }
      }
    end
    assert_template 'edit'
  end

  test 'should update user with valid input data' do
    travel 1.hours do 
      assert_changes '@sample_topic.reload.updated_at' do
        patch admin_topic_path(@sample_topic), params: {
          topic: {
            # TODO: add valid input data here
            name: 'something very unique'
          }
        }
      end
    end
    assert_response :redirect
    assert_redirected_to admin_topic_path(@sample_topic)
    assert_not flash.empty?
    assert_equal 'Topic has successfully been updated', flash[:success]
  end

  test 'should destroy topic' do
    assert_difference 'Topic.count', -1 do
      delete admin_topic_path(@sample_topic)
    end
    assert_response :redirect
    assert_redirected_to admin_topics_path
    assert_not flash.empty?
    assert_equal 'Topic has successfully been deleted', flash[:success]
  end
end

