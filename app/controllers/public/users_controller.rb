class Public::UsersController < ApplicationController
  before_action :is_matching_log_in_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :update, :confirm, :follows, :followers]
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.includes(:user).page(params[:page])
    # @recipes = @user.recipes.page(params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.all.page(params[:page]).per(8)
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "変更に成功しました！"
      redirect_to user_path(user.id)
    else
      flash.now[:alert] = "変更に失敗しました"
      render :edit
    end
  end

  def confirm #退会確認画面
    @user = User.find(params[:id])
  end

  def withdraw #退会機能（論理削除）
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session #セキュリティー対策
    flash[:notice] = "退会処理を実行致しました"
    redirect_to root_path
  end
  
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user: @user.id).pluck(:recipe_id)
    @recipes = Recipe.where(id: favorites).page(params[:page])
  end
  
  def follows
    user = User.find(params[:id])
    # @recipes = Recipe.where(user: user)
    @follows = user.followings.page(params[:page]).per(8)
    
  end
  
  def followers
    user = User.find(params[:id])
    @followers = user.followers.page(params[:page]).per(8)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end
  
  #自分以外のユーザーのプロフィールは編集できないようにする
  def is_matching_log_in_user
    user = User.find(params[:id])
    unless current_admin
      unless user.id == current_user.id
        flash[:alert] = "他ユーザーの編集画面には遷移できません"
        redirect_to recipes_path
      end
    end
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user), alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
  
end
