require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:john)
    log_in_as @admin
  end

  test 'should get index' do
    get admin_users_path
    assert_response :success
    assert_template 'index'
  end

  test 'should paginate users' do
    get admin_users_path
    assert_select 'main nav.pagination', count: 2
    first_page_of_users = User.paginate(page: 1, per_page: 20)
    assert_select 'ul#pagination-items' do
      assert_select 'li', 20
    end
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', admin_user_path(user), text: user.full_name
      assert_select 'a[href=?]', edit_admin_user_path(user), text: 'edit'
      assert_select 'a[href=?][data-method="delete"]', admin_user_path(user),
                    text: 'delete'
    end
  end

  test 'should get show' do
    get admin_user_path(@admin)
    assert_response :success
    assert_template 'show'
  end

  test 'should link back to index page on show' do
    get admin_user_path(@admin)
    assert_select 'a[href=?]', admin_users_path, text: 'Back to index page'
  end 

  test 'should link to edit page on show' do
    get admin_user_path(@admin)
    assert_select 'a[href=?]', edit_admin_user_path(@admin), text: 'Edit'
  end

  test 'should display user information' do
    get admin_user_path(@admin)
    assert_select 'h1', text: @admin.full_name
    assert_select 'p#name', text: "name: #{@admin.name}"
    assert_select 'p#surname', text: "surname: #{@admin.surname}"
    assert_select 'p#email', text: "email: #{@admin.email}"
    assert_select 'p#created_at', text: "created_at: #{@admin.created_at}"
    assert_select 'p#updated_at', text: "updated_at: #{@admin.updated_at}"
    assert_select 'p#admin', text: "admin: #{@admin.admin}"
    assert_select 'p#activated', text: "activated: #{@admin.activated}"
    assert_select 'p#activated_at', text: "activated_at: #{@admin.activated_at}"
  end

  test 'should get new' do
    get new_admin_user_path
    assert_response :success
    assert_template 'new'
  end

  test 'should link to new on index page' do
    get admin_users_path
    assert_response :success
    assert_template 'index'
    assert_select 'a[href=?]', new_admin_user_path, text: 'New user'
  end

  test 'should render a form for user creation' do
    get new_admin_user_path
    assert_select 'form[action="/admin/users"]'
  end

  test 'should link back to index page on new' do
    get new_admin_user_path
    assert_select 'a[href=?]', admin_users_path, text: 'Back to index page'
  end 

  test 'should get edit' do
    get edit_admin_user_path(@admin)
    assert_response :success
    assert_template 'edit'
    assert_not flash.empty?
    warning_msg = 'WARNING: be very careful when altering field values'
    assert_equal warning_msg, flash.now[:warning]
  end
  
  test 'should link back to index page on edit' do
    get edit_admin_user_path(@admin)
    assert_select 'a[href=?]', admin_users_path, text: 'Back to index page'
  end 

  test 'should link to show page on edit' do
    get edit_admin_user_path(@admin)
    assert_select 'a[href=?]', admin_user_path(@admin), text: 'View information'
  end

  test 'should not create a user with invalid input data' do
    assert_no_difference 'User.count' do
      post admin_users_path, params: { user: { name: '',
                                               surname: '',
                                               email: 'email@invalid', 
                                               password: '',
                                               password_confirmation: '',
                                               activated: false, 
                                               admin: false } }
    end
    assert_template 'new'
  end

  test 'should create a user with valid input data' do
    assert_difference 'User.count', 1 do
      post admin_users_path, params: { user: { name: 'Albert',
                                               surname: 'Einstein',
                                               email: 'genius@example.com', 
                                               password: 'password',
                                               password_confirmation: 'password',
                                               activated: false, 
                                               admin: true } }
    end
    assert_response :redirect 
    assert_not flash.empty?
    assert_equal 'User has been created', flash[:success]
  end

  test 'should not update user with invalid input data' do
    travel 1.hours # ensure last time updated is not now
    assert_no_changes '@admin.reload.updated_at' do
      patch admin_user_path(@admin), params: {
        user: { name: '',
                surname: '',
                email: 'email@invalid',
                password: '',
                password_confirmation: '',
                activated: false,
                admin: false }
      }
    end
    assert_template 'edit'
  end

  test 'should update user with valid input data' do
    travel 1.hours do 
      assert_changes '@admin.reload.updated_at' do
        patch admin_user_path(@admin), params: {
          user: { name: 'Matt',
                  surname: @admin.surname,
                  email: @admin.email,
                  password: '',
                  password_confirmation: '',
                  activated: @admin.activated,
                  admin: @admin.admin }
        }
      end
    end
    assert_response :redirect
    assert_redirected_to admin_user_path(@admin)
    assert_not flash.empty?
    assert_equal 'User has successfully been updated', flash[:success]
  end

  test 'should destroy user' do
    assert_difference 'User.count', -1 do
      delete admin_user_path(@admin)
    end
    assert_response :redirect
    assert_redirected_to admin_users_path
    assert_not flash.empty?
    assert_equal 'User has successfully been deleted', flash[:success]
  end
end

