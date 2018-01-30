require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'should get show' do
    get user_path @user
    assert_response :success
    assert_template 'users/show'
  end

  test 'should get new' do
    get signup_path 
    assert_response :success
    assert_template 'users/new'
  end

  test 'should create a new user when valid information is posted' do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                          email: 'genius@example.com',
                                          password:              'password',
                                          password_confirmation: 'password', } }
    end
    assert_response :redirect
  end

  test 'should not create a new user when invalid information is posted' do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', surname: '',
                                          email: 'email@invalid',
                                          password:              'short',
                                          password_confirmaiton: 'long' } }
    end
    assert_template 'users/new'
  end
end

