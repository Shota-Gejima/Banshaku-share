class Public::RecipesController < ApplicationController
  before_action :search_recipe, only: [:index, :search]
  before_action :is_matching_log_in_user, only: [:edit, :update]
  
  def new
    unless current_admin
      @recipe = Recipe.new
    else
      flash[:alert] = "管理者はおつまみを投稿できません"
      redirect_to admin_users_path
    end
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
      redirect_to recipe_path(@recipe.id)
    else
      render :edit
    end
  end
  
  def index
   @recipes = Recipe.sort_by(params)
   @sort_by = sort_by(params)
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
  
  def sort_by(params)
    if params[:latest]
       "新着順"
    elsif params[:old]
      "古い順"
    elsif params[:most_favorited]
      "いいねが多い順"
    elsif params[:most_viewed]
     "閲覧数が多い順"
    else
     "新着順"
    end
  end
  
  def is_matching_log_in_user
    user = User.find(params[:id])
    unless current_admin
      if user.id != current_user.id
        flash[:alert] = "他ユーザーが投稿したおつまみの編集画面には遷移できません"
        redirect_to recipes_path
      end
    end
  end
  
end