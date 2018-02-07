require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:john)
    @non_admin= users(:michael)
  end

  test 'index as non-admin' do
    log_in_as @non_admin
    get users_path
    assert_template 'users/index'
    assert_select 'main > .pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.full_name
    end
    assert_select 'a', text: 'delete', count: 0
  end

  test 'index as an admin user' do
    log_in_as @admin
    get users_path
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|  
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
end

