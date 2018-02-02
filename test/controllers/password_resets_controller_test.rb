require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @user.create_reset_digest
  end

  test 'should get new' do
    get new_password_reset_path
    assert_response :success
    assert_template 'password_resets/new'
  end

  test 'should not get edit with invalid token' do
    get edit_password_reset_path('invalid token', email: @user.email)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should not get edit with invalid email' do
    get edit_password_reset_path(@user.reset_token, email: 'email@invalid')
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should get edit with valid reset token and email' do 
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_response :success
    assert_template 'password_resets/edit'
  end

  test 'should not get edit with expired reset token' do
    travel 2.hours + 1.seconds
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_response :redirect
    assert_redirected_to new_password_reset_url
  end

  test 'should not get edit with an inactive user' do
    @user.toggle!(:activated)
    get edit_password_reset_path(@user.reset_token, email: @user.email)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should not send an email to invalid email address' do
    clear_deliveries
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      post password_resets_path, params: { password_reset: { email: '' } }
    end
  end

  test 'should send an email to a valid email address' do
    clear_deliveries
    assert_difference 'ActionMailer::Base.deliveries.size', 1 do
      post password_resets_path, params: { 
        password_reset: { email: @user.email }
      }
    end
  end

  test 'should produce an error if password is not inputted' do
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email,
      user: { password: '', password_confirmation: '' }
    }
    assert_select 'div#error-explanation'
  end

  test 'should not update user if password does not match confirmation' do
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email,
      user: { password: 'password', password_confirmation: 'qwerty123' }
    }
    assert_equal @user.password_digest, @user.reload.password_digest
  end

  test 'should update user if all inputted data is valid' do
    # ensure user.updated_at changes if the user is successfully updated
    travel 1.hours 
    assert_changes '@user.reload.updated_at' do
      patch password_reset_path(@user.reset_token), params: {
        email: @user.email,
        user: { password: 'password', password_confirmation: 'password' }
      }
    end
  end
end

