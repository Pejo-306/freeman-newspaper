class Admin::ModelManagerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_model_generator
    template 'controller.rb.erb',
             "app/controllers/admin/#{file_name.pluralize}_controller.rb"
  end
end

