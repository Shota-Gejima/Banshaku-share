class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :read_counts, dependent: :destroy
  
  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowing_id(フォローする側)
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
   # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following
  
  # favoriteモデルを介していいねされたおつまみを取り出す
  # has_many :favorited_recipes, through: :favorites, source: :recipe
  
  validates :name, presence: { message: 'を入力してください' }, length: { maximum: 7, message: 'は7文字以内で入力してください' }
  validates :birthday, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }, presence: { message: 'を選択してください' }
  validates :introduction, allow_blank: true, length: { maximum: 50, message: 'は50文字以内で入力してください' }
  # 20歳未満は登録させないカスタムバリデーション
  validate :age_should_be_over_20, if: -> { birthday.present? }
  
  # いいねされたおつまみの多い順
  # scope :most_favorited_recipes, -> {includes(:favorited_recipes)
    # .sort_by {|x| x.favorited_recipes.includes(:favorites).size }. reverse }
    
  # 20歳未満は登録させないカスタムメソッド
  def age_should_be_over_20
    if age < 20
      errors.add(:birthday, "は20歳未満は登録できません")
    end
  end
  
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image_user.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image_user.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # 退会機能(論理削除)is_deletedがfalseならtrueを返す
  def active_for_authentication?
    super && (is_deleted == false)
  end
  
  # ゲストユーザー作成
  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.birthday = Date.new(1980, 11, 11)
      user.introduction = "ゲストユーザです。よろしくお願いします。"
    end
  end
  
  # ゲストユーザーか判定
  def guest_user?
    email == "guest@example.com"
  end
  
# 生年月日から年齢を計算する
  def age
    today = Time.zone.today
    this_years_birthday = Time.zone.local(today.year, birthday.month, birthday.day)
    age = today.year - birthday.year
    age -= 1 if today < this_years_birthday
    age
  end
  
  # 総閲覧数
  def total_views
    recipes.joins(:read_counts).count
  end
  
  # 総いいね数
  def total_favorites
    recipes.joins(:favorites).count
  end
  
end
