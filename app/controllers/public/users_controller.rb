class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.page(params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(current_user.id)
  end

  def confirm #退会確認画面を表示させるだけのため空欄
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
  
  private
  
  def user_params
    params.require(:user).permit(:profile_image, :name, :introduction)
  end
end
