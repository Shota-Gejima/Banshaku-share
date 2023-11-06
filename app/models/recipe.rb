class Recipe < ApplicationRecord
  
  has_one_attached :recipe_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :alcohol
  belongs_to_active_hash :food
  belongs_to_active_hash :making_time
  
  def get_recipe_image(width, height)
    unless recipe_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      recipe_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    recipe_image.variant(resize_to_limit: [width, height]).processed
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
