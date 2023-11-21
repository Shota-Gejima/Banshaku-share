class Public::HomesController < ApplicationController
  
  def top
    @recipes = Recipe.order('id DESC').limit(3)
    if params[:from_confirm_view]
      flash.now[:alert] = "申し訳ございません。20歳未満の方はご利用になられません。"
    end
  end
  
  def about
  end
  
  def confirm
  end
end
