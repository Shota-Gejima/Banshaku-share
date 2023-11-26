class Public::CommentsController < ApplicationController
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    comment = current_user.comments.new(comment_params)
    comment.recipe_id = @recipe.id
    unless comment.save
      flash[:alert] = "コメントは1文字以上50文字以内で入力してください"
      redirect_to request.referer
    end
  end
  
  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    Comment.find(params[:id]).destroy
    if admin_signed_in?
      redirect_to request.referer
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
