require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com') }
  let(:recipient_user) { User.create!(name: 'Recipient User', email: 'recipient@example.com') }
  let(:wallet) { Wallet.create!(user: user, balance: 100.0) }
  let(:recipient_wallet) { Wallet.create!(user: recipient_user, balance: 50.0) }

  describe 'POST #deposit' do
    it 'deposits the specified amount into the wallet' do
      post :deposit, params: { id: wallet.id, amount: 50.0 }
      wallet.reload
      expect(wallet.balance).to eq(150.0)
    end
  end

  describe 'POST #withdraw' do
    it 'withdraws the specified amount from the wallet' do
      post :withdraw, params: { id: wallet.id, amount: 50.0 }
      wallet.reload
      expect(wallet.balance).to eq(50.0)
    end
  end

  describe 'POST #transfer' do
    it 'transfers the specified amount to the recipient wallet' do
      post :transfer, params: { id: wallet.id, recipient_id: recipient_wallet.id, amount: 50.0 }
      wallet.reload
      recipient_wallet.reload
      expect(wallet.balance).to eq(50.0)
      expect(recipient_wallet.balance).to eq(100.0)
    end
  end

  describe 'GET #user_balance' do
    it 'returns the balance of the user\'s wallet' do
      get :user_balance, params: { user_id: user.id }
      expect(response.body).to include_json(balance: wallet.balance)
    end
  end

  describe 'GET #user_transactions' do
    it 'returns the transactions of the user\'s wallet' do
      wallet.transactions.create!(amount: 50.0, transaction_type: 'deposit')
      get :user_transactions, params: { user_id: user.id }
      expect(response.body).to include_json([{ amount: 50.0, transaction_type: 'deposit' }])
    end
  end
end