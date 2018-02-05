require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
  end

  test 'site header' do
    get root_path
    assert_select 'header' do
      assert_select '#title a[href=?]', root_path, text: "The Freeman's newspaper"
      assert_select 'nav ul.nav'
    end
  end

  test 'site header as anonymous user' do
    get root_path
    assert_select 'header' do
      assert_select 'nav ul.nav li' do
        assert_select 'a[href=?]', signup_path, text: 'Sign up'
        assert_select 'a[href=?]', login_path, text: 'Log in'
      end
    end
  end

  test 'site header as logged in user' do
    log_in_as @user
    get root_path
    assert_select 'header' do
      assert_select 'nav ul.nav' do
        assert_select 'li.dropdown' do
          assert_select 'a.dropdown-toggle' do
            assert_select 'span.header-link-text', text: 'Account'
          end

          assert_select 'ul.dropdown-menu li' do
            assert_select 'a[href=?]', user_path(@user), text: 'Profile'
            assert_select 'a[href=?]', edit_user_path(@user), text: 'Settings'
            assert_select 'a[href=?]', logout_path, text: 'Log out'
          end
        end
      end
    end
  end

  test 'site footer' do
    get root_path
    assert_select 'footer' do
      travel_to Date.new(2018, 1, 1) do
        assert_select '#copyright', text: "\u00A9 2018 Pejo-306"
      end
    end
  end
end

