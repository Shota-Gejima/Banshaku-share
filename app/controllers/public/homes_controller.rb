class Public::HomesController < ApplicationController
  
  def top
    @recipes = Recipe.order('id DESC').limit(3)
    if params[:from_confirm_view]
      flash.now[:alert] = "申し訳ございません。20歳未満の方はご利用になられません。"
    end
  end
  
  # 画面表示だけの為未記入
  def about
  end
  
  # 画面表示だけの為未記入
  def confirm
  end
  
end
