class Admin::ModelManagerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_model_generator
    @controller_name = file_name.singularize.capitalize
    @record_name = @controller_name.downcase
    model = @controller_name.classify.constantize
    @model_fields = model.attribute_names - ['id', 'created_at', 'updated_at']
    @model_fields.map! { |field| ":#{field}" }

    template 'controller.rb.erb',
             "app/controllers/admin/#{file_name.pluralize}_controller.rb"
  end

  def create_controller_views
    restful_actions = ['index', 'show', 'new', 'edit']
    restful_actions.each do |action|
      template "#{action}.html.erb.erb",
               "app/views/admin/#{file_name.pluralize}/#{action}.html.erb"
    end
  end
end

