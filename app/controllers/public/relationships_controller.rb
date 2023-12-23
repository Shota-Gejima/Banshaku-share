class Public::RelationshipsController < ApplicationController
  
  def create
    @user = User.find(params[:user_id])
    relationship_count = Relationship.where(following_id: current_user.id).where(follower_id: @user.id).count
    if relationship_count == 0
      follow = current_user.active_relationships.build(follower_id: params[:user_id])
      follow.save
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
  end
  
end
