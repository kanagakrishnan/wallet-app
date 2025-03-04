class WalletsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:deposit, :withdraw, :transfer]

  def index
    @wallets = Wallet.all
    render json: @wallets
  end

  def show
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet
      render json: @wallet
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def create
    @wallet = Wallet.new(wallet_params)
    if @wallet.save
      render json: @wallet, status: :created
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  def update
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet && @wallet.update(wallet_params)
      render json: @wallet
    else
      render json: { error: 'Wallet not found or update failed' }, status: :unprocessable_entity
    end
  end

  def destroy
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet
      @wallet.destroy
      head :no_content
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def check_balance
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet
      render json: { balance: @wallet.balance }
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def deposit
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet
      amount = params[:amount].to_f
      begin
        @wallet.deposit(amount)
        render json: @wallet
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def withdraw
    @wallet = Wallet.find_by(id: params[:id])
    if @wallet
      amount = params[:amount].to_f
      begin
        @wallet.withdraw(amount)
        render json: @wallet
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Wallet not found' }, status: :not_found
    end
  end

  def transfer
    sender_wallet = Wallet.find_by(id: params[:id])
    recipient_wallet = Wallet.find_by(id: params[:recipient_id])
    if sender_wallet && recipient_wallet
      amount = params[:amount].to_f
      begin
        sender_wallet.transfer(amount, recipient_wallet)
        render json: { sender: sender_wallet, recipient: recipient_wallet }
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Sender or recipient wallet not found' }, status: :not_found
    end
  end

  def user_balance
    @wallet = Wallet.find_by_user_id(params[:user_id])
    render json: { balance: @wallet.balance }
  end

  def user_transactions
    @wallet = Wallet.find_by_user_id(params[:user_id])
    @transactions = @wallet.transactions
    render json: @transactions
  end

  private

  def wallet_params
    params.require(:wallet).permit(:balance)
  end
end
