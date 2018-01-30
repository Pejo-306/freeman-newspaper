require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'unsuccessful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', surname: '',
                                              email: 'email@invalid',
                                              password:              'wrong',
                                              password_confirmation: 'pass' } }
    assert_template 'users/edit'
  end

  test 'successful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Albert'
    surname = 'Einstein'
    email = 'genius@example.com'
    patch user_path(@user), params: { user: { name: name, surname: surname,
                                              email: email,
                                              password:              '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_equal 'Profile updated', flash[:success]
    assert_response :redirect
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal surname, @user.surname
    assert_equal email, @user.email
  end

  test 'friendly forwarding' do
    get edit_user_path(@user)
    log_in_as @user
    assert_redirected_to edit_user_path(@user)
  end
end

