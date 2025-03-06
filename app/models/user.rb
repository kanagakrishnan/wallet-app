class User < ApplicationRecord
  has_one :wallet

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
