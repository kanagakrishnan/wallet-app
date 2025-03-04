# Clear existing data
Transaction.destroy_all
Wallet.destroy_all
User.destroy_all

# Create sample users
users = User.create!([
  { name: 'Alice', email: 'alice@example.com' },
  { name: 'Bob', email: 'bob@example.com' },
  { name: 'Charlie', email: 'charlie@example.com' }
])

# Create sample wallets for each user
wallets = users.map do |user|
  Wallet.create!(user: user, balance: rand(100..1000))
end

# Create sample transactions for each wallet
wallets.each do |wallet|
  5.times do
    amount = rand(10..100)
    transaction_type = %w[deposit withdraw].sample
    if transaction_type == 'withdraw' && wallet.balance < amount
      transaction_type = 'deposit'
    end
    wallet.transactions.create!(amount: amount, transaction_type: transaction_type)
    wallet.update(balance: wallet.balance + (transaction_type == 'deposit' ? amount : -amount))
  end
end

puts "Seeded #{User.count} users, #{Wallet.count} wallets, and #{Transaction.count} transactions."