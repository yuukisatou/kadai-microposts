class User < ApplicationRecord

  before_save { self.email.downcase! }
  # name のバリデーション
  validates :name, presence: true, length: { maximum: 50 }
  # email のバリデーション
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  # パスワードを暗号化して保存する
  has_secure_password
  
  has_many :microposts

  # フォローフォロワー機能
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relatioship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relatioship, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  
  # お気に入り機能
  has_many :favorites
  has_many :likes, through: :favorites, source: :favpost
  has_many :reverses_of_favorite, class_name: "Favorite", foreign_key: "favpost_id"
  has_many :likelists, through: :reverses_of_favorite, source: :user
  
  def likepost(micropost)
    self.favorites.find_or_create_by(favpost_id: micropost.id)
  end
  
  def unlikepost(micropost)
    favorite = self.favorites.find_by(favpost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def faving?(micropost)
    likes.include?(micropost)
  end

  
end
