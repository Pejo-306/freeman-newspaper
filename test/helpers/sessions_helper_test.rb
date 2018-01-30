require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  setup do
    @user = users(:john)
    @other = users(:michael)
  end

  test 'logged_in? returns true if the user is logged in' do
    log_in @user
    assert logged_in?
  end

  test 'logged_in? returns false if the user is not logged in' do
    assert_not logged_in?
    log_in @user
    log_out
    assert_not logged_in?
  end

  test 'current_user returns the right user when the session is nil' do
    remember @user
    assert_equal @user, current_user
    assert logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    remember @user
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'current_user? returns false if the given user is not the current user' do
    log_in_as @user
    assert current_user?(@user)
  end

  test 'current_user? returns true if the given user is the current user' do
    log_in_as @other
    assert_not current_user?(@user)
  end
end

