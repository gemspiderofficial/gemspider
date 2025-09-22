-- GemSpider Token Presale Database Schema
-- Generated from rawdatabase2.json structure

-- Users table to store wallet holders and user information
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended'))
);

-- Transactions table to store all token purchase transactions
CREATE TABLE transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    transaction_hash VARCHAR(255) UNIQUE NOT NULL,
    from_address VARCHAR(255) NOT NULL,
    to_address VARCHAR(255) NOT NULL,
    ton_amount DECIMAL(18, 9) NOT NULL,
    spider_amount DECIMAL(18, 9) NOT NULL,
    exchange_rate DECIMAL(10, 9) NOT NULL,
    transaction_type VARCHAR(20) DEFAULT 'purchase' CHECK (transaction_type IN ('purchase', 'transfer', 'refund')),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'cancelled')),
    created_at DATETIME NOT NULL,
    confirmed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Balances table to store current wallet balances
CREATE TABLE balances (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER UNIQUE NOT NULL,
    wallet_address VARCHAR(255) UNIQUE NOT NULL,
    ton_balance DECIMAL(18, 9) DEFAULT 0.000000000,
    spider_balance DECIMAL(18, 9) DEFAULT 0.000000000,
    last_updated DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Presale configuration table
CREATE TABLE presale_config (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    token_name VARCHAR(50) NOT NULL,
    token_symbol VARCHAR(10) NOT NULL,
    contract_address VARCHAR(255) UNIQUE NOT NULL,
    receiver_address VARCHAR(255) NOT NULL,
    exchange_rate DECIMAL(10, 9) NOT NULL,
    min_purchase DECIMAL(18, 9) NOT NULL,
    max_purchase DECIMAL(18, 9) NOT NULL,
    total_supply DECIMAL(18, 9) NOT NULL,
    sold_amount DECIMAL(18, 9) DEFAULT 0.000000000,
    presale_start DATETIME NOT NULL,
    presale_end DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'completed', 'cancelled')),
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
);

-- Indexes for better performance
CREATE INDEX idx_users_wallet_address ON users(wallet_address);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_hash ON transactions(transaction_hash);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_balances_user_id ON balances(user_id);
CREATE INDEX idx_balances_wallet_address ON balances(wallet_address);