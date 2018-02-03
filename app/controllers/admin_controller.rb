class AdminController < ApplicationController
  before_action :require_login
  before_action :require_admin_status

  def index
    Rails.application.eager_load! if Rails.env.development?
    # Retrieve only resources who have been added to the namespace 'admin'
    # This is accomplished by evaluating the existence of the
    # appropriate namespaced resource url/path method
    @models = ApplicationRecord.descendants
    @models.select! do |model|
      eval("defined?(admin_#{model.name.downcase.pluralize}_url)")
    end
  end
end

