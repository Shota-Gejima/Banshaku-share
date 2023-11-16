class Admin::CommentsController < ApplicationController
  
  def index
    @user = User.find(params[:user_id])
    @comments = @user.comments.page(params[:page]).per(10)
  end

  def destroy
  end
end
