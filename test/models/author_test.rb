require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  setup do
    @author = users(:sample_author)
  end

  test 'should be valid' do
    assert @author.valid?
  end

  test 'should have author status by default' do
    new_author = Author.create(name: 'New',
                               surname: 'Author',
                               email: 'new@example.com',
                               password: 'password',
                               password_confirmation: 'password')
    assert new_author.author?
  end
end

