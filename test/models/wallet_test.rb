require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'Test User', email: 'test@example.com')
    @recipient_user = User.create!(name: 'Recipient User', email: 'recipient@example.com')
    @wallet = Wallet.create!(user: @user, balance: 100.0)
    @recipient_wallet = Wallet.create!(user: @recipient_user, balance: 50.0)
  end

  test 'deposit increases the balance by the specified amount' do
    @wallet.deposit(50.0)
    assert_equal 150.0, @wallet.reload.balance
  end

  test 'deposit creates a deposit transaction' do
    assert_difference '@wallet.transactions.count', 1 do
      @wallet.deposit(50.0)
    end
    assert_equal 'deposit', @wallet.transactions.last.transaction_type
  end

  test 'withdraw decreases the balance by the specified amount' do
    @wallet.withdraw(50.0)
    assert_equal 50.0, @wallet.reload.balance
  end

  test 'withdraw creates a withdraw transaction' do
    assert_difference '@wallet.transactions.count', 1 do
      @wallet.withdraw(50.0)
    end
    assert_equal 'withdraw', @wallet.transactions.last.transaction_type
  end

  test 'withdraw raises an error if the amount is greater than the balance' do
    assert_raises(ArgumentError, 'Insufficient funds') do
      @wallet.withdraw(150.0)
    end
  end

  test 'transfer transfers the specified amount to the recipient wallet' do
    @wallet.transfer(50.0, @recipient_wallet)
    assert_equal 50.0, @wallet.reload.balance
    assert_equal 100.0, @recipient_wallet.reload.balance
  end

  test 'transfer creates transfer transactions for both wallets' do
    assert_difference '@wallet.transactions.count', 1 do
      @wallet.transfer(50.0, @recipient_wallet)
    end
    assert_equal 'transfer', @wallet.transactions.last.transaction_type

    assert_difference '@recipient_wallet.transactions.count', 1 do
      @wallet.transfer(50.0, @recipient_wallet)
    end
    assert_equal 'transfer', @recipient_wallet.transactions.last.transaction_type
  end

  test 'transfer raises an error if the amount is greater than the balance' do
    assert_raises(ArgumentError, 'Insufficient funds') do
      @wallet.transfer(150.0, @recipient_wallet)
    end
  end
end