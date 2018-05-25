require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :john
    @other_user = users :michael
    @author = authors :sample_author
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should get index when logged in' do
    log_in_as @user
    get users_path
    assert_response :success
    assert_template 'users/index'
  end

  test 'should display only activated users on index page' do
    @other_user.update_attribute(:activated, false)
    log_in_as @user
    get users_path
    assert_select 'a', text: @other_user.full_name, count: 0
  end

  test 'should get show' do
    get user_path(@user)
    assert_response :success
    assert_template 'users/show'
  end

  test 'should redirect show page for inactivated account' do
    @other_user.update_attribute(:activated, false)
    get user_path(@other_user)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should get new' do
    get signup_path 
    assert_response :success
    assert_template 'users/new'
  end

  test 'should get edit when user is logged in' do
    log_in_as @user
    get edit_user_path(@user)
    assert_response :success
    assert_template 'users/edit'
  end

  test 'should redirect edit when user is not logged in' do
    get edit_user_path(@user)
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
  end

  test 'should redirect update when user is not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              surname: @user.surname,
                                              email: @user.email } }
    assert_response :redirect
    assert_redirected_to login_url
    assert_not flash.empty?
    assert_equal 'Please log in', flash[:danger]
    assert_equal @user, @user.reload # user has not been changed
  end

  test 'should redirect edit when logged in as the wrong user' do
    log_in_as @other_user
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_equal 'You do not have permission to alter this account', flash[:danger]
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as the wrong user' do
    log_in_as @other_user
    patch user_path(@user), params: { user: { name: @user.name,
                                              surname: @user.surname,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_equal 'You do not have permission to alter this account', flash[:danger]
    assert_response :redirect
    assert_redirected_to root_url
    assert_equal @user, @user.reload # user has not been changed
  end

  test 'should create a new user when valid information is posted' do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Albert', surname: 'Einstein',
                                          email: 'genius@example.com',
                                          password:              'password',
                                          password_confirmation: 'password', } }
    end
    assert_response :redirect
  end

  test 'should not create a new user when invalid information is posted' do
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', surname: '',
                                          email: 'email@invalid',
                                          password:              'short',
                                          password_confirmaiton: 'long' } }
    end
    assert_template 'users/new'
  end

  test 'should not update user when invalid information is posted' do
    log_in_as @user
    patch user_path(@user), params: { user: { name: '', surname: '',
                                              email: '',
                                              password: 'wrong',
                                              password_confirmation: 'pass' } }
    assert_equal @user, @user.reload
  end

  test 'should update user when valid information is posted' do
    log_in_as @user
    name = 'Albert'
    surname = 'Einstein'
    patch user_path(@user), params: { user: { name: name, surname: surname } }
    @user.reload
    assert_equal name, @user.name
    assert_equal surname, @user.surname
  end

  test "should only alter an account's author status when the right parameter is posted" do
    log_in_as @user
    assert_not @user.author?
    assert_no_difference 'Column.count' do
      patch user_path(@user), params: { user: { name: 'Sample name' } }
    end
    @user.reload
    assert_not @user.author?
  end

  test 'should not allow anonymous users to alter the author status of any account' do
    assert_not @user.author?
    assert_not @other_user.author?
    assert_no_difference 'Column.count' do
      patch user_path(@user), params: { user: { author: 'true' } }
      patch user_path(@other_user), params: { user: { author: 'true' } }
    end
    @user.reload
    @other_user.reload
    assert_not @user.author?
    assert_not @other_user.author?
  end

  test 'should allow only the owner of an account to alter its author status' do
    log_in_as @other_user
    assert_not @user.author?
    assert_no_difference 'Column.count' do
      patch user_path(@user), params: { user: { author: 'true' } }
    end
    @user.reload
    assert_not @user.author?
  end

  test 'should give the user author status and create a column' do
    log_in_as @user
    assert_not @user.author?
    assert_difference 'Column.count', 1 do
      patch user_path(@user), params: { user: { author: 'true' } }
    end
    @user.reload
    assert @user.author?
    assert_not flash.empty?
    assert_equal 'Congratulations! You are now an author!', flash[:success]
  end

  test 'should not allow the user to edit the admin attribute' do
    log_in_as @other_user
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { admin: true } }
    assert_not @other_user.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :redirect
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in as the owner of the account' do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_equal 'You do not have permission to alter this account', flash[:danger]
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should delete user' do
    log_in_as @other_user
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_not flash.empty?
    assert_equal 'User deleted', flash[:success]
    assert_response :redirect
    assert_redirected_to users_url
  end

  test 'should delete author and all of their articles and their column' do
    log_in_as @author
    assert_difference 'User.count', -1 do
      assert_difference 'Column.count', -1 do
        assert_difference 'Article.count', -@author.column.articles.count do
          delete user_path(@author)
        end
      end
    end
    assert_not flash.empty?
    assert_equal 'User deleted', flash[:success]
    assert_response :redirect
    assert_redirected_to users_url
  end
end

