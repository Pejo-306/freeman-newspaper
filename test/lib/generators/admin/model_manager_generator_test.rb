require 'test_helper'
require 'generators/admin/model_manager/model_manager_generator'

class Admin::ModelManagerGeneratorTest < Rails::Generators::TestCase
  tests Admin::ModelManagerGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test 'generator runs without errors' do
    assert_nothing_raised do
      run_generator ['user']
    end
  end

  test 'generator does not create anything when specified model does not exist' do
    run_generator ['some_model']
    assert_no_file 'app/controllers/admin/users_controller.rb'

    # Views
    assert_no_file 'app/views/admin/users/index.html.erb'
    assert_no_file 'app/views/admin/users/show.html.erb'
    assert_no_file 'app/views/admin/users/new.html.erb'
    assert_no_file 'app/views/admin/users/edit.html.erb'
    assert_no_file 'app/views/admin/users/_form.html.erb'
    assert_no_file 'app/views/admin/users/_user.html.erb'
  end

  test 'generator creates a model controller' do
    run_generator ['user']
    assert_file 'app/controllers/admin/users_controller.rb'
  end

  test 'generator creates views for every RESTful action' do
    run_generator ['user']
    assert_file 'app/views/admin/users/index.html.erb'
    assert_file 'app/views/admin/users/show.html.erb'
    assert_file 'app/views/admin/users/new.html.erb'
    assert_file 'app/views/admin/users/edit.html.erb'
  end

  test 'generator creates the partials required by the views' do
    run_generator ['user']
    assert_file 'app/views/admin/users/_form.html.erb'
    assert_file 'app/views/admin/users/_user.html.erb'
  end
end

