class Admin::ModelManagerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_model_generator
    invoke 'controller', ["admin/#{file_name.pluralize}"]
  end
end

