class Admin::UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @fields = displayed_user_attrs
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
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

  private

  def displayed_user_attrs
    [:name, :surname, :email, :created_at, :updated_at,
     :admin, :activated, :activated_at]
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :activated, :admin,
                                 :password, :password_confirmation)
  end
end

