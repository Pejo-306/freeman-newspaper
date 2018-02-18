require 'test_helper'
require 'generators/admin/model_manager/model_manager_generator'

class Admin::ModelManagerGeneratorTest < Rails::Generators::TestCase
  tests Admin::ModelManagerGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  test 'generator runs without errors' do
    assert_nothing_raised do
      run_generator ["article"]
    end
  end

  test 'generator invokes controller generator' do
    run_generator ["article"]
    assert_file 'app/controllers/admin/articles_controller.rb'
  end
end
