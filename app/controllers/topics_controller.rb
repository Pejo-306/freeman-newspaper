class TopicsController < ApplicationController
  before_action :require_login, only: :exists

  def index
    @topics = Topic.paginate(page: params[:page], per_page: 6).order('RANDOM()')
  end

  def exists
    output = { exists: !Topic.find_by_name(params[:name]).nil? }
    render json: output.to_json
  end
end

