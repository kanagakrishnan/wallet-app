class User < ApplicationRecord
  has_many :wallets

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
