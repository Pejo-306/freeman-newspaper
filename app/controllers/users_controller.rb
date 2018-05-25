class UsersController < ApplicationController
  before_action :require_login, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    unless @user.activated?
      redirect_to root_url
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:author] == 'true'
      if Time.zone.now - @user.created_at > 30.days
        @user.update_attributes(author: true)
        Column.create(author: Author.find(@user.id))
        flash[:success] = 'Congratulations! You are now an author!'
      else
        flash[:danger] = "Your account is not old enough " +
                         "(#{(Time.zone.now - @user.created_at).to_i / 1.day} days old) " +
                         "to have author status"
      end
      redirect_to @user
    elsif @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.author?
      author = Author.find(user.id)
      column = author.column
      column.articles.each { |article| article.destroy }
      column.destroy
    end
    user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :email,
                                 :password, :password_confirmation)
  end

  # Forbid an arbitrary user from editing any other users' information
  def correct_user
    @user = User.find(params[:id])
    unless current_user? @user
      flash[:danger] = 'You do not have permission to alter this account'
      redirect_to root_url
    end
  end
end

