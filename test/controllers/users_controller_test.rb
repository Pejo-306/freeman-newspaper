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

  test 'should get edit' do
    get edit_user_path @user
    assert_response :success
    assert_template 'users/edit'
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

  test 'should not update user when invalid information is posted' do
    updated_at = @user.updated_at
    patch user_path(@user), params: { user: { name: '', surname: '',
                                              email: '',
                                              password: 'wrong',
                                              password_confirmation: 'pass' } }
    @user.reload
    assert_equal updated_at, @user.updated_at
  end

  test 'should update user when valid information is posted' do
    name = 'Albert'
    surname = 'Einstein'
    previously_updated = @user.updated_at
    patch user_path(@user), params: { user: { name: name, surname: surname,
                                              email: @user.email,
                                              password:              '',
                                              password_confirmation: '' } }
    @user.reload
    assert_not_equal previously_updated, @user.updated_at
    assert_equal name, @user.name
    assert_equal surname, @user.surname
  end
end

