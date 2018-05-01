class TopicsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_admin_status, except: [:index, :show]

  def new
    @topic = Topic.new
  end
end

