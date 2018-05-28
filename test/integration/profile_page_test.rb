require 'test_helper'

class ProfilePageTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :michael
  end

  test 'should not get profile page for anonymous users' do
    get profile_path
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal "Please, log in to access your profile's page", flash[:danger]
  end

  test 'should get profile page' do
    log_in_as @user
    get profile_path
    assert_response :success
    assert_template 'users/show'
  end

  test "should display user's info" do
    log_in_as @user
    get profile_path
    assert_select 'span', text: @user.name
    assert_select 'span', text: @user.surname
    assert_select 'span', text: @user.email
    assert_select 'p',    text: @user.biography
    assert_select 'a[href=?]', user_path(@user), text: 'Delete account'
  end
end

