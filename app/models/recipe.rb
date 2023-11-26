class Recipe < ApplicationRecord
  
  has_one_attached :recipe_image
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  # favoriteモデルを介していいねしたユーザーを取り出す
  has_many :favorited_users, through: :favorites, source: :user
  # read_countモデルを介して閲覧したしたユーザーを取り出す
  has_many :viewed_users, through: :read_counts, source: :user
 
  validates :recipe_image, presence: { message: 'を入力してください' }
  validates :title, presence: { message: 'を入力してください' }, length: { maximum: 20, message: 'は20文字以内で入力してください' }
  validates :description, presence: { message: 'を入力してください' }, length: { maximum: 50, message: 'は50文字以内で入力してください' }
  validates :process, presence: { message: 'を入力してください' }, length: { maximum: 255, message: 'は255文字以内で入力してください' }
  validates :alcohol_id, presence: { message: 'を選択してください' }
  validates :food_id, presence: { message: 'を選択してください' }
  validates :making_time_id, presence: { message: 'を選択してください' }

  # 並び替え機能
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :most_favorited, -> {includes(:favorited_users)
    .sort_by {|x| x.favorited_users.includes(:favorites).size }. reverse }
  scope :most_viewed, -> {includes(:viewed_users)
    .sort_by {|x| x.viewed_users.includes(:read_counts).size }. reverse }
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :alcohol
  belongs_to_active_hash :food
  belongs_to_active_hash :making_time
  
  def get_recipe_image(width, height)
    unless recipe_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      recipe_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    recipe_image.variant(resize_to_fit: [width, height]).processed
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def total_view(user)
    user.read_counuts.count
  end
  
  #どの属性を検索可能にするかを明示的に制御している
  def self.ransackable_attributes(auth_object = nil)
    ["alcohol_id", "description", "food_id", "id", "making_time_id", "process", "title", "user_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
  ["alcohol", "food", "making_time", "user"]
  end
  
  def self.sort_by(params)
    if params[:latest]
      latest.page(params[:page])
    elsif params[:old]
      old.page(params[:page])
    elsif params[:most_favorited]
      recipes = most_favorited
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
    elsif params[:most_viewed]
      recipes = most_viewed
      @recipes = Kaminari.paginate_array(recipes).page(params[:page])
    else
      latest.page(params[:page])
    end
  end
  
end