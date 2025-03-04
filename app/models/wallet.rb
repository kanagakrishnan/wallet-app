class Wallet < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy


  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount)
    raise ArgumentError, 'Amount must be positive' if amount <= 0
    ActiveRecord::Base.transaction do
      self.balance += amount
      transactions.create!(amount: amount, transaction_type: 'deposit')
      save!
    end
  end

  def withdraw(amount)
    raise ArgumentError, 'Insufficient funds' if amount > balance
    raise ArgumentError, 'Amount must be positive' if amount <= 0
    ActiveRecord::Base.transaction do
      self.balance -= amount
      transactions.create!(amount: amount, transaction_type: 'withdraw')
      save!
    end
  end

  def transfer(amount, recipient_wallet)
    raise ArgumentError, 'Insufficient funds' if amount > balance
    raise ArgumentError, 'Amount must be positive' if amount <= 0
    ActiveRecord::Base.transaction do
      self.balance -= amount
      recipient_wallet.balance += amount
      transactions.create!(amount: amount, transaction_type: 'transfer')
      recipient_wallet.transactions.create!(amount: amount, transaction_type: 'transfer')
      save!
      recipient_wallet.save!
    end
  end
end
