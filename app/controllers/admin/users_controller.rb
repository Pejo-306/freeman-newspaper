class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin_status

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def show
    @fields = displayed_user_attrs
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    flash.now[:warning] = 'WARNING: be very careful when altering field values'
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'User has been created'
      redirect_to admin_user_path(@user)
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'User has successfully been updated'
      redirect_to admin_user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = 'User has successfully been deleted'
    redirect_to admin_users_path
  end

  private

  def displayed_user_attrs
    [:name, :surname, :email, :activated, :admin, :activated_at]
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :activated, :admin,
                                 :password, :password_confirmation)
  end
end

