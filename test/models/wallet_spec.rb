require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com') }
  let(:recipient_user) { User.create!(name: 'Recipient User', email: 'recipient@example.com') }
  let(:wallet) { Wallet.create!(user: user, balance: 100.0) }
  let(:recipient_wallet) { Wallet.create!(user: recipient_user, balance: 50.0) }

  describe '#deposit' do
    it 'increases the balance by the specified amount' do
      wallet.deposit(50.0)
      expect(wallet.balance).to eq(150.0)
    end

    it 'creates a deposit transaction' do
      expect { wallet.deposit(50.0) }.to change { wallet.transactions.count }.by(1)
      expect(wallet.transactions.last.transaction_type).to eq('deposit')
    end
  end

  describe '#withdraw' do
    it 'decreases the balance by the specified amount' do
      wallet.withdraw(50.0)
      expect(wallet.balance).to eq(50.0)
    end

    it 'creates a withdraw transaction' do
      expect { wallet.withdraw(50.0) }.to change { wallet.transactions.count }.by(1)
      expect(wallet.transactions.last.transaction_type).to eq('withdraw')
    end

    it 'raises an error if the amount is greater than the balance' do
      expect { wallet.withdraw(150.0) }.to raise_error(ArgumentError, 'Insufficient funds')
    end
  end

  describe '#transfer' do
    it 'transfers the specified amount to the recipient wallet' do
      wallet.transfer(50.0, recipient_wallet)
      expect(wallet.balance).to eq(50.0)
      expect(recipient_wallet.balance).to eq(100.0)
    end

    it 'creates transfer transactions for both wallets' do
      expect { wallet.transfer(50.0, recipient_wallet) }.to change { wallet.transactions.count }.by(1)
      expect(wallet.transactions.last.transaction_type).to eq('transfer')
      expect { wallet.transfer(50.0, recipient_wallet) }.to change { recipient_wallet.transactions.count }.by(1)
      expect(recipient_wallet.transactions.last.transaction_type).to eq('transfer')
    end

    it 'raises an error if the amount is greater than the balance' do
      expect { wallet.transfer(150.0, recipient_wallet) }.to raise_error(ArgumentError, 'Insufficient funds')
    end
  end
end