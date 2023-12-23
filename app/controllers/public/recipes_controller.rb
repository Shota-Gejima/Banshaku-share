class Public::RecipesController < ApplicationController
  before_action :search_recipe, only: [:index, :search]
  before_action :is_matching_log_in_user, only: [:destroy, :edit, :update]
  
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
    # before_actionで実行のため未記入
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
    search_params = params[:q]
    alcohol_id = search_params[:alcohol_id_eq]
    food_id = search_params[:food_id_eq]
    making_time_id = search_params[:making_time_id_eq]
    @alcohol = find_model(Alcohol, alcohol_id)
    @food = find_model(Food, food_id)
    @making_time = find_model(MakingTime, making_time_id)
    # 空検索はさせない
    @result = search_params&.values&.reject(&:blank?)
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:recipe_image, :alcohol_id, :food_id, :making_time_id, :title, :description, :process)
  end
  
  def find_model(model_class, id)
    model_class.find_by(id: id)
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
    @recipe = Recipe.find(params[:id])
    unless current_admin
      if @recipe.user.id != current_user.id
        flash[:alert] = "他ユーザーが投稿したおつまみの編集・削除はできません"
        redirect_to recipes_path
      end
    end
  end
  
   # 検索機能
  def search_recipe
    @q = Recipe.ransack(params[:q])
  end
  
end