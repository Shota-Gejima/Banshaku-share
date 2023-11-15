class Public::RecipesController < ApplicationController
  
  before_action :search_recipe, only: [:index, :show, :edit, :search]
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      flash[:notice] = "保存に成功しました"
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:notice] = "更新に成功しました"
      redirect_to recipes_path
    else
      flash.now[:alert] = "未入力項目があり更新に失敗しました"
      render :edit
    end
  end
  
  def index
    @recipes = Recipe.includes(:user).order("created_at DESC").page(params[:page])
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @comments = @recipe.comments.page(params[:page]).per(8)
    @comment = Comment.new
    if user_signed_in?
      unless ReadCount.where(created_at: Time.zone.now.all_day).find_by(recipe_id: @recipe.id, user_id: current_user)
        current_user.read_counts.create!(recipe_id: @recipe.id)
      end
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    redirect_to recipes_path
  end
  
  def search
    @recipes = @q.result.page(params[:page])
    alcohol_id = params[:q][:alcohol_id_eq]
    food_id = params[:q][:food_id_eq]
    making_time_id = params[:q][:making_time_id_eq]
    @alcohol = Alcohol.find_by(id: alcohol_id)
    @food = Food.find_by(id: food_id)
    @making_time = MakingTime.find_by(id: making_time_id)
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:recipe_image, :alcohol_id, :food_id, :making_time_id, :title, :description, :process)
  end
  
  def search_recipe
    @q = Recipe.ransack(params[:q])
  end
end
