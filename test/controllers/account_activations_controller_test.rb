require 'test_helper'

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                        email: 'genius@example.com',
                                        password:              'password',
                                        password_confirmation: 'password' } }
    @user = assigns(:user)
  end

  test 'should not activate account with invalid activation token' do
    get edit_account_activation_path('invalid token', email: @user.email)
    assert_not @user.reload.activated?
  end

  test 'should not activate account with invalid user email' do
    get edit_account_activation_path(@user.activation_token, email: 'invalid')
    assert_not @user.reload.activated?
  end

  test 'should activate account with valid email and activation token' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
  end
end

