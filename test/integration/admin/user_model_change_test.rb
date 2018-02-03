require 'test_helper'

class Admin::UserModelChangeTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'unsuccessful user update' do
    get edit_admin_user_path(@user)
    assert_response :success
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@user.id}\"]"
    travel 1.hours do
      assert_no_changes '@user.reload.updated_at' do
        patch admin_user_path(@user), params: { user: { name: '',
                                                        surname: '',
                                                        email: 'email@invalid',
                                                        password: '',
                                                        password_confirmation: '',
                                                        activated: @user.activated,
                                                        admin: @user.admin } }
      end
    end
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@user.id}\"]"
    assert_select 'div#error-explanation>div.alert',
                  text: 'The form contains 3 errors.'
    assert_select 'div#error-explanation>ul' do
      assert_select 'li', count: 3
    end
  end

  test 'successful user update' do
    get edit_admin_user_path(@user)
    assert_response :success
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@user.id}\"]"
    travel 1.hours do
      assert_changes '@user.reload.updated_at' do
        patch admin_user_path(@user), params: { 
          user: { name: 'Albert',
                  surname: 'Einstein',
                  email: 'genius@example.com' }
        }
      end
    end
    assert_response :redirect
    assert_redirected_to admin_user_path(@user)
    follow_redirect!
    assert_template 'show'
    assert_not flash.empty?
    assert_equal 'User has successfully been updated', flash[:success]
    assert_select 'h1', text: 'Albert Einstein'
    assert_select 'p#name', text: 'name: Albert'
    assert_select 'p#surname', text: 'surname: Einstein'
    assert_select 'p#email', text: 'email: genius@example.com' 
    assert_select 'p#updated_at', text: "updated_at: #{Time.zone.now + 1.hours}"
  end
end

