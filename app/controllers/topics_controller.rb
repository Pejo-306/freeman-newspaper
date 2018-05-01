class TopicsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_admin_status, except: [:index, :show]

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'Topic has been created'
      redirect_to topics_path
    else
      render 'new'
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end
end

