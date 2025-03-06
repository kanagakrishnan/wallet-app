require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: 'Test User', email: 'test@example.com')
    @recipient_user = User.create!(name: 'Recipient User', email: 'recipient@example.com')
    @wallet = Wallet.create!(user: @user, balance: 100.0)
    @recipient_wallet = Wallet.create!(user: @recipient_user, balance: 50.0)
  end

  test 'should deposit the specified amount into the wallet' do
    post deposit_wallet_url(@wallet), params: { amount: 50.0 }
    @wallet.reload
    assert_equal 150.0, @wallet.balance
  end

  test 'should create a deposit transaction' do
    assert_difference '@wallet.transactions.count', 1 do
      post deposit_wallet_url(@wallet), params: { amount: 50.0 }
    end
    assert_equal 'deposit', @wallet.transactions.last.transaction_type
  end

  test 'should withdraw the specified amount from the wallet' do
    post withdraw_wallet_url(@wallet), params: { amount: 50.0 }
    @wallet.reload
    assert_equal 50.0, @wallet.balance
  end

  test 'should create a withdraw transaction' do
    assert_difference '@wallet.transactions.count', 1 do
      post withdraw_wallet_url(@wallet), params: { amount: 50.0 }
    end
    assert_equal 'withdraw', @wallet.transactions.last.transaction_type
  end

  test 'should return the balance of the user\'s wallet' do
    get user_balance_url(@user)
    assert_response :success
    assert_includes @response.body, @wallet.balance.to_s
  end

  test 'should return the transactions of the user\'s wallet' do
    @wallet.transactions.create!(amount: 50.0, transaction_type: 'deposit')
    get user_transactions_url(@user)
    assert_response :success
    assert_includes @response.body, 'deposit'
  end
end
