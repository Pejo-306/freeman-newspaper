require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:john)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert @user.invalid?, 'Name is blank'
  end
  
  test 'name should not be longer than 50 characters' do
    @user.name = 'a' * 50
    assert @user.valid?
    @user.name += 'a'
    assert @user.invalid?, 'A name longer than 50 letters is accepted'
  end

  test 'surname should be present' do
    @user.surname = ''
    assert @user.invalid?, 'Surname is blank'
  end

  test 'surname should not be longer than 50 characters' do
    @user.surname = 'a' * 50
    assert @user.valid?
    @user.surname += 'a'
    assert @user.invalid?, 'A surname longer than 50 letters is accepted'
  end

  test 'email should be present' do
    @user.email = ''
    assert @user.invalid?, 'Email is blank'
  end 

  test 'email should not be longer than 255 characters' do
    @user.email = 'a' * 243 + '@example.com'
    assert @user.valid?
    @user.email = 'a' + @user.email
    assert @user.invalid?, 'An email longer than 255 letters is accepted'
  end

  test 'valid email addresses should be accepted' do
    valid_emails = %w[
      user@example.com USER@example.com A-US_ER@foo.bar.org
      first.last@foo.jp pejo+pesho@spam.com
    ]
    valid_emails.each do |email|
      @user.email = email
      assert @user.valid?, "Valid email (#{email}) address is not accepted"
    end
  end

  test 'invalid email addresses should be accepted' do
    invalid_emails = %w[
      user@example,com user_at_example.com user.name@example.
      foo@bar_baz.com foo@bar..com foo@bar+baz.com
    ]
    invalid_emails.each do |email|
      @user.email = email
      assert @user.invalid?, "Invalid email (#{email}) address is accepted"
    end
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email address should be saved as lower-case' do
    mixed_case_email = 'Foo@EXAMPLE.cOm'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 8
    assert @user.invalid?, 'Password is not present'
  end

  test 'password should be at least 8 characters long' do
    @user.password = @user.password_confirmation = 'a' * 7
    assert @user.invalid?, 'Password under 8 characters is accepted'
    @user.password = @user.password_confirmation = 'a' * 8
    assert @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'full_name returns a concatenation of the first and last names' do
    full_name = "#{@user.name} #{@user.surname}"
    assert_equal full_name, @user.full_name
  end
end

