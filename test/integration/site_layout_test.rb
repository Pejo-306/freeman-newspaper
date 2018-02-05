require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'site header as anonymous user' do
    get root_path
    assert_select 'header'
    assert_select 'header div#logo a[href=?]', root_path
    assert_select 'header div#title a[href=?]', root_path
    assert_select 'header div#title a[href=?] span#name', root_path,
                  text: "The Freeman's"
    assert_select 'header div#title a[href=?] span#newspaper', root_path,
                  text: "newspaper"
    assert_select 'header nav'
  end
end

