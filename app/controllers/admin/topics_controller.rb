class Admin::TopicsController < ApplicationController
  before_action :require_login
  before_action :require_admin_status

  def index
    @topics = Topic.paginate(page: params[:page], per_page: 20)
  end

  def show
    @fields = displayed_topic_attrs
    @topic = Topic.find(params[:id])
  end

  def new
    @fields = displayed_topic_attrs
    @topic = Topic.new
  end

  def edit
    flash.now[:warning] = 'WARNING: be very careful when altering field values'
    @fields = displayed_topic_attrs
    @topic = Topic.find(params[:id])
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'Topic has been created'
      redirect_to admin_topic_path(@topic)
    else
      @fields = displayed_topic_attrs
      render 'new'
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Topic has successfully been updated'
      redirect_to admin_topic_path(@topic)
    else
      @fields = displayed_topic_attrs
      render 'edit'
    end
  end

  def destroy 
    Topic.find(params[:id]).destroy
    flash[:success] = 'Topic has successfully been deleted'
    redirect_to admin_topics_path
  end

  private
  
  def displayed_topic_attrs
    {
      name: nil
    }
  end

  def topic_params
    params.require(:topic).permit(
      :name
    )
  end
end

