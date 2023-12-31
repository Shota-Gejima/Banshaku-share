class Public::UsersController < ApplicationController
  before_action :is_matching_log_in_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :update]
  before_action :search_user, only: [:index, :search]
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.includes(:user).page(params[:page])
    if params[:from_confirm_view]
      flash.now[:notice] = "引き続きお楽しみください！"
    end
  end

  def edit
    # before_actionで実行のため未記入
  end

  def index
    @users = User.sort_by(params)
    @sort_by = sort_by(params)
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "変更に成功しました"
      redirect_to user_path(@user.id)
    else
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
    @recipes = @user.favorited_recipes.page(params[:page])
  end
  
  def follows
    user = User.find(params[:id])
    @follows = user.followings.page(params[:page]).per(8)
  end
  
  def followers
    user = User.find(params[:id])
    @followers = user.followers.page(params[:page]).per(8)
  end
  
  def search
    @users = @q.result.page(params[:page])
    # 空検索はさせない
    @result = params[:q]&.values&.reject(&:blank?)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end
  
  #自分以外のユーザーのプロフィールは編集できないようにする
  def is_matching_log_in_user
    @user = User.find(params[:id])
    unless current_admin
      if @user.id != current_user.id
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
  
  def sort_by(params)
    if params[:old]
      "古い順"
    elsif params[:latest]
      "新着順"
    elsif params[:most_recipes]
      "投稿数が多い順"
    elsif params[:most_favorited_recipes]
      "いいね獲得総数が多い順"
    elsif params[:most_followers]
      "フォロワー数が多い順"
    elsif params[:most_viewed]
      "総閲覧数が多い順"
    else 
      "古い順"
    end
  end
  
   # 検索機能
  def search_user
    @q = User.ransack(params[:q])
  end
  
end
