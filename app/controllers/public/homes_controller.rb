class Public::HomesController < ApplicationController
  
  def top
    @recipes = Recipe.order('id DESC').limit(3)
  end
  
  def about
  end
  
  def confirm
  end
end
