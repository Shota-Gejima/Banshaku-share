class Recipe < ApplicationRecord
  
  has_one_attached :recipe_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :recipe_image, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :process, presence: true
  validates :alcohol_id, presence: true
  validates :food_id, presence: true
  validates :making_time_id, presence: true

  
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
  
  
  def self.ransackable_attributes(auth_object = nil) #どの属性を検索可能にするかを明示的に制御している
    ["alcohol_id", "created_at", "description", "food_id", "id", "making_time_id", "process", "title", "updated_at", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
  ["alcohol", "comments", "favorites", "food", "making_time", "recipe_image_attachment", "recipe_image_blob", "user"]
  end
end
