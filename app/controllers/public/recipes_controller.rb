class Public::RecipesController < ApplicationController
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = current_user.recipes.new(recipe_params)
    @recipe.save
    redirect_to recipes_path
    
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    
  end
  
  def update
    recipe = Recipe.find(params[:id])
    recipe.update(recipe_params)
    redirect_to recipes_path
  end
  
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:recipe_image, :alcohol_id, :food_id, :making_time_id, :title, :description, :process)
  end
  
end
