require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:john)
    @user = users(:michael)
  end

  test 'site header' do
    get root_path
    assert_select 'header' do
      assert_select '#title a[href=?]', root_path, text: "The Freeman's newspaper"
      assert_select 'nav.nav'
    end
  end

  test 'site header as anonymous user' do
    get root_path
    assert_select 'header' do
      assert_select 'nav.nav' do
        assert_select 'a[href=?]', signup_path, text: 'Sign up'
        assert_select 'a[href=?]', login_path, text: 'Log in'
      end
    end
  end

  test 'site header as logged in user' do
    log_in_as @user
    get root_path
    assert_select 'header' do
      assert_select 'nav.nav' do
        assert_select '.dropdown' do
          assert_select 'a.dropdown-toggle' 

          assert_select '.dropdown-menu' do
            assert_select 'a[href=?]', user_path(@user), text: 'Profile'
            assert_select 'a[href=?]', edit_user_path(@user), text: 'Settings'
            assert_select 'a[href=?]', logout_path, text: 'Log out'
          end
        end
      end
    end
  end

  test "hyperlink to admin page in site's header" do
    # Non-logged in users should not be displayed a link to admin page
    get root_path
    assert_select 'header' do
      assert_select 'nav.nav' do
        assert_select 'a[href=?]', admin_path, false
      end
    end

    # There shouldn't be a link to the admin page for non-admin users
    log_in_as @user
    get root_path
    assert_select 'header' do
      assert_select 'nav.nav' do
        assert_select 'a[href=?]', admin_path, false
      end
    end

    # There should be a link to the admin page for admin users
    log_in_as @admin
    get root_path
    assert_select 'header' do
      assert_select 'nav.nav' do
        assert_select 'a[href=?]', admin_path, text: 'Admin'
      end
    end
  end

  test 'site footer' do
    get root_path
    assert_select 'footer' do
      travel_to Date.new(2018, 1, 1) do
        assert_select '#copyright', text: "\u00A9 2018 Pejo-306"
      end

      assert_select '.breadcrumb' do 
        assert_select 'a[href=?]', root_path, false
        assert_select 'a[href=?]', about_path, 'About'
      end
    end

    get about_path
    assert_select 'footer' do
      assert_select '.breadcrumb' do 
        assert_select 'a[href=?]', root_path, 'Home' 
        assert_select 'a[href=?]', about_path, false
      end
    end
  end

  test "hyperlink to admin page in site's footer" do
    # Non-logged in users should not be displayed a link to admin page
    get root_path
    assert_select 'footer' do
      assert_select 'nav[aria-label="breadcrumb"]' do
        assert_select 'a[href=?]', admin_path, false
      end
    end

    # There shouldn't be a link to the admin page for non-admin users
    log_in_as @user
    get root_path
    assert_select 'footer' do
      assert_select 'nav[aria-label="breadcrumb"]' do
        assert_select 'a[href=?]', admin_path, false
      end
    end

    # There should be a link to the admin page for admin users
    log_in_as @admin
    get root_path
    assert_select 'footer' do
      assert_select 'nav[aria-label="breadcrumb"]' do
        assert_select 'a[href=?]', admin_path, text: 'Admin'
      end
    end
  end
end

