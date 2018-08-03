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
  
  
end
