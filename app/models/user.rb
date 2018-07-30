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
end
