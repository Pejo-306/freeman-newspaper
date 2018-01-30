require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'index with pagination' do
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.full_name
    end
  end
end

