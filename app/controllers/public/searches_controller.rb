class Public::SearchesController < ApplicationController
  
  def search
    alcohol_id = params[:alcohol_id]
    @alcohols = Recipe.where(alcohol_id: alcohol_id)
  end
end
