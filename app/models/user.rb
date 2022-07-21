class User < ApplicationRecord
  has_many :entries
  before_save :encrypting

  validates :name, :email, :password, presence: true
  validates :email, uniqueness: true

  def encrypting
    # パスワード暗号化処理
    self.password = BCrypt::Password.create(self.password)
  end
end
