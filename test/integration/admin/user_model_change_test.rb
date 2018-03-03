require 'test_helper'

class Admin::UserModelChangeTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    log_in_as @admin
  end

  test 'unsuccessful user update' do
    get edit_admin_user_path(@admin)
    assert_response :success
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@admin.id}\"]"
    travel 1.hours do
      assert_no_changes '@admin.reload.updated_at' do
        patch admin_user_path(@admin), params: { user: { name: '',
                                                        surname: '',
                                                        email: 'email@invalid',
                                                        password: '',
                                                        password_confirmation: '',
                                                        activated: @admin.activated,
                                                        admin: @admin.admin } }
      end
    end
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@admin.id}\"]"
    assert_select '#error-explanation > p', text: 'The form contains 3 errors:'
    assert_select '#error-explanation > ul' do
      assert_select 'li', count: 3
    end
  end

  test 'successful user update' do
    get edit_admin_user_path(@admin)
    assert_response :success
    assert_template 'edit'
    assert_select "form[action=\"/admin/users/#{@admin.id}\"]"
    travel 1.hours do
      assert_changes '@admin.reload.updated_at' do
        patch admin_user_path(@admin), params: { 
          user: { name: 'Albert',
                  surname: 'Einstein',
                  email: 'genius@example.com' }
        }
      end
    end
    assert_response :redirect
    assert_redirected_to admin_user_path(@admin)
    follow_redirect!
    assert_template 'show'
    assert_not flash.empty?
    assert_equal 'User has successfully been updated', flash[:success]
    assert_select 'h1', text: 'User: Albert Einstein'
    assert_select 'p#name', text: 'name: Albert'
    assert_select 'p#surname', text: 'surname: Einstein'
    assert_select 'p#email', text: 'email: genius@example.com' 
    assert_select 'span#updated_at', text: "#{Time.zone.now + 1.hours}"
  end
end

