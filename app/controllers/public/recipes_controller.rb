class Public::RecipesController < ApplicationController
  
  before_action :search_recipe, only: [:index, :search]
  
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
    if params[:latest]
      @recipes = Recipe.latest.page(params[:page])
      @sort_order = "新着順"
    elsif params[:old]
      @recipes = Recipe.old.page(params[:page])
      @sort_order = "古い順"
    elsif params[:most_favorited]
      recipes = Recipe.most_favorited
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
      @sort_order = "いいねが多い順"
    elsif params[:most_viewed]
      recipes = Recipe.most_viewed
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
      @sort_order = "閲覧数が多い順"
    else
      @recipes = Recipe.includes(:user).order("created_at DESC").page(params[:page])
      @sort_order = "新着順"
    end
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @comments = @recipe.comments.page(params[:page]).per(8)
    @comment = Comment.new
    # 管理者が閲覧してもカウントされない
    if user_signed_in?
      unless ReadCount.where(created_at: Time.zone.now.all_day).find_by(recipe_id: @recipe.id, user_id: current_user)
        current_user.read_counts.create!(recipe_id: @recipe.id)
      end
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    if recipe.destroy
      flash[:notice] = "削除に成功しました"
      redirect_to recipes_path
    end
  end
  
  def search
    @recipes = @q.result.page(params[:page])
    alcohol_id = params[:q][:alcohol_id_eq]
    food_id = params[:q][:food_id_eq]
    making_time_id = params[:q][:making_time_id_eq]
    @alcohol = Alcohol.find_by(id: alcohol_id)
    @food = Food.find_by(id: food_id)
    @making_time = MakingTime.find_by(id: making_time_id)
    # 空検索はさせない
    @result = params[:q]&.values&.reject(&:blank?)
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:recipe_image, :alcohol_id, :food_id, :making_time_id, :title, :description, :process)
  end
  
  # 検索機能
  def search_recipe
    @q = Recipe.ransack(params[:q])
  end
  
end
