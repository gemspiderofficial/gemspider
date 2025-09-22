-- GemSpider Token Presale Database
-- Complete database setup with schema and data
-- Converted from rawdatabase2.json

-- ==================================================
-- SCHEMA CREATION
-- ==================================================

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

-- ==================================================
-- DATA INSERTION
-- ==================================================

-- Insert users data
INSERT INTO users (id, wallet_address, username, email, created_at, updated_at, status) VALUES
(1, 'EQBUMjg7ROfjh_ou3Lz1lpNrTJN59h2S-Wm-ZPsWWVzn-xc9', 'spider_user_1', 'user1@example.com', '2024-01-15 10:30:00', '2024-01-15 10:30:00', 'active'),
(2, 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 'spider_user_2', 'user2@example.com', '2024-01-16 14:20:00', '2024-01-16 14:20:00', 'active'),
(3, 'EQC7VpEHw2DA9hxkdx9RNS5l6RGUIjmCCDhK3TBu9UYN', 'spider_user_3', 'user3@example.com', '2024-01-17 09:15:00', '2024-01-17 09:15:00', 'active');

-- Insert transactions data
INSERT INTO transactions (id, user_id, transaction_hash, from_address, to_address, ton_amount, spider_amount, exchange_rate, transaction_type, status, created_at, confirmed_at) VALUES
(1, 1, 'a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456', 'EQBUMjg7ROfjh_ou3Lz1lpNrTJN59h2S-Wm-ZPsWWVzn-xc9', 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 1.000000000, 50.000000000, 0.020000000, 'purchase', 'completed', '2024-01-15 11:00:00', '2024-01-15 11:02:00'),
(2, 2, 'b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567a', 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 2.500000000, 125.000000000, 0.020000000, 'purchase', 'completed', '2024-01-16 15:30:00', '2024-01-16 15:32:00'),
(3, 3, 'c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567ab2', 'EQC7VpEHw2DA9hxkdx9RNS5l6RGUIjmCCDhK3TBu9UYN', 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 0.500000000, 25.000000000, 0.020000000, 'purchase', 'pending', '2024-01-17 10:00:00', NULL);

-- Insert balances data
INSERT INTO balances (id, user_id, wallet_address, ton_balance, spider_balance, last_updated) VALUES
(1, 1, 'EQBUMjg7ROfjh_ou3Lz1lpNrTJN59h2S-Wm-ZPsWWVzn-xc9', 15.750000000, 50.000000000, '2024-01-15 11:02:00'),
(2, 2, 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 22.500000000, 125.000000000, '2024-01-16 15:32:00'),
(3, 3, 'EQC7VpEHw2DA9hxkdx9RNS5l6RGUIjmCCDhK3TBu9UYN', 9.500000000, 0.000000000, '2024-01-17 10:00:00');

-- Insert presale configuration data
INSERT INTO presale_config (id, token_name, token_symbol, contract_address, receiver_address, exchange_rate, min_purchase, max_purchase, total_supply, sold_amount, presale_start, presale_end, status, created_at, updated_at) VALUES
(1, 'SPIDER', 'SPIDER', 'EQBUMjg7ROfjh_ou3Lz1lpNrTJN59h2S-Wm-ZPsWWVzn-xc9', 'UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST', 0.020000000, 0.010000000, 100.000000000, 1000000.000000000, 200.000000000, '2024-01-15 00:00:00', '2024-03-15 23:59:59', 'active', '2024-01-14 12:00:00', '2024-01-17 10:00:00');

-- ==================================================
-- VERIFICATION QUERIES
-- ==================================================

-- Verify data integrity
-- SELECT 'Users count:' as info, COUNT(*) as count FROM users;
-- SELECT 'Transactions count:' as info, COUNT(*) as count FROM transactions;
-- SELECT 'Balances count:' as info, COUNT(*) as count FROM balances;
-- SELECT 'Presale config count:' as info, COUNT(*) as count FROM presale_config;