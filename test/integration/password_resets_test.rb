require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  setup do
    clear_deliveries
    @user = users(:john)
  end

  test 'email form' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # Invalid email passed to email form
    post password_resets_path, params: { password_reset: { email: 'email' } }
    assert_template 'password_resets/new'
    assert_not flash.empty?
    assert_equal 'Email address not found', flash.now[:danger]

    # Valid email passed to email form
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_response :redirect
    assert_redirected_to root_url
    assert_not flash.empty?
    info_msg = "Email sent to #{@user.email} with password reset instructions"
    assert_equal info_msg, flash[:info]
  end

  test 'password reset form' do
    post password_resets_path, params: { password_reset: { email: @user.email } }
    user = assigns(:user)

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: 'email')
    assert_response :redirect
    assert_redirected_to root_url

    # Wrong token (with correct email)
    get edit_password_reset_path('', email: user.email)
    assert_response :redirect
    assert_redirected_to root_url

    # Inactive user
    user.toggle!(:activated) # switch to false
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_response :redirect
    assert_redirected_to root_url
    user.toggle!(:activated) # switch to true

    # Expired reset token
    travel 2.hours + 1.seconds do
      get edit_password_reset_path(user.reset_token, email: user.email)
      assert_response :redirect
      assert_redirected_to new_password_reset_url
      assert_not flash.empty?
      assert_equal 'Password reset has expired', flash[:danger]
    end

    # Correct email and token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_response :success
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Invalid password and confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password: 'password', password_confirmation: 'qwerty123' }
    }
    assert_template 'password_resets/edit'
    assert_select 'div#error-explanation'

    # Empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password: '', password_confirmation: '' }
    }
    assert_template 'password_resets/edit'
    assert_select 'div#error-explanation'

    # Matching password and confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: { password: 'password', password_confirmation: 'password' }
    }
    assert logged_in?
    assert_nil user.reload.reset_digest
    assert_response :redirect
    assert_redirected_to user
    assert_not flash.empty?
    assert_equal 'Password has been reset', flash[:success]
  end
end

