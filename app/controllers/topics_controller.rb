class TopicsController < ApplicationController
  before_action :require_login

  def exists
    output = { exists: !Topic.find_by_name(params[:name]).nil? }
    render json: output.to_json
  end
end

