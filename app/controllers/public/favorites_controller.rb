class Public::FavoritesController < ApplicationController
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    favorite_count = Favorite.where(user_id: current_user, recipe_id: @recipe).count
    if favorite_count == 0
      favorite = current_user.favorites.new(recipe_id: @recipe.id)
      favorite.save
    end
  end
  
  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    favorite = current_user.favorites.find_by(recipe_id: @recipe.id)
    favorite.destroy
  end
  
end
