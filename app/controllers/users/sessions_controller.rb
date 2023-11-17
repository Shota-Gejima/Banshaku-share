class Users::SessionsController < Devise::SessionsController
    
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to recipes_path, notice: "ゲストユーザーでログインしました"
  end
  
  def guest_sign_out
    user = User.guest
    delete_guest_user_data(user)
    sign_out(user)
    redirect_to root_path, notice: "ゲストユーザーでログアウトしました"
  end
  
  private
  
  # ゲストがログアウトしたらデータはすべて削除
  def delete_guest_user_data(user)
  user.recipes.destroy_all
  user.comments.destroy_all
  user.favorites.destroy_all
  user.followings.destroy_all
  end
  
end