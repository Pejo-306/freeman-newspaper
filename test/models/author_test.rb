require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  setup do
    @author = authors :sample_author
  end

  test 'should be valid' do
    assert @author.valid?, @author.errors.messages
  end

  test 'should be at least 30 days old' do
    new_author = Author.create(name: 'New',
                               surname: 'Author',
                               email: 'new@example.com',
                               created_at: Time.zone.now - 10.days,
                               biography: 'Sample biography',
                               password: 'password',
                               password_confirmation: 'password')
    assert_not new_author.valid?
    new_author.created_at -= 30.days
    assert new_author.valid?
  end

  test 'should have author status by default' do
    new_author = Author.create(name: 'New',
                               surname: 'Author',
                               email: 'new@example.com',
                               created_at: Time.zone.now + 40.days,
                               biography: 'Sample biography',
                               password: 'password',
                               password_confirmation: 'password')
    assert new_author.author?
  end

  test 'should have a biography' do
    assert @author.valid?
    assert_not_nil @author.biography
    @author.biography = nil
    assert_nil @author.biography
    assert_not @author.valid?
  end
end

