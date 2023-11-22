class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments.order("created_at DESC").page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
    
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "変更内容の保存に成功しました"
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :birthday, :is_deleted)
  end
  
end
