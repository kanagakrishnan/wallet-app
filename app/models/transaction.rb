class Transaction < ApplicationRecord
  belongs_to :wallet

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[deposit withdraw transfer] }
end