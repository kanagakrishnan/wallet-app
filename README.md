# Wallet App

This is a simple wallet application built with Ruby on Rails. The application allows users to create wallets, deposit and withdraw funds, transfer funds between wallets, and view their balance and transaction history.

## Features

- Create wallets
- Deposit funds into wallets
- Withdraw funds from wallets
- Transfer funds between wallets
- View wallet balance
- View transaction history

## Requirements

- Ruby 3.4.2
- Rails 8.0.1
- PostgreSQL (for development and testing)

## Setup

1. Clone the repository:

   ```sh
   git clone https://github.com/kanagakrishnan/wallet-app.git
   cd wallet-app
   ```

2. Install the dependencies:

   ```sh
   bundle install
   ```

3. Set up the database:

   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the Rails server:

   ```sh
   rails server
   ```

5. Open your browser and navigate to [http://localhost:3000](http://localhost:3000) to access the application.

## API Endpoints

### Wallets

#### Create Wallet

- **URL:** `POST /wallets`
- **Parameters:** `{ "user_id": 1, "balance": 100.0 }`

#### Deposit Funds

- **URL:** `POST /wallets/:id/deposit`
- **Parameters:** `{ "amount": 50.0 }`

#### Withdraw Funds

- **URL:** `POST /wallets/:id/withdraw`
- **Parameters:** `{ "amount": 50.0 }`

#### Transfer Funds

- **URL:** `POST /wallets/:id/transfer`
- **Parameters:** `{ "recipient_id": 2, "amount": 50.0 }`

#### Check Balance

- **URL:** `GET /wallets/:id/check_balance`

### User Balance

- **URL:** `GET /user_balance/:user_id`

### User Transactions

- **URL:** `GET /user_transactions/:user_id`

## Running Tests

To run the test suite, use the following command:

```sh
rails test
```

Make sure all pending migrations are applied to the test database:

```sh
rails db:test:prepare
```
