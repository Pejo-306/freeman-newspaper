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

  private

  def displayed_user_attrs
    [:name, :surname, :email, :created_at, :updated_at,
     :admin, :activated, :activated_at]
  end
end

