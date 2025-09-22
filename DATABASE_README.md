# GemSpider Database Conversion

This repository contains the database structure and conversion tools for the GemSpider token presale application.

## Files

### Database Files
- `rawdatabase2.json` - Source JSON data file containing user, transaction, balance, and presale configuration data
- `database_schema.sql` - SQL schema definitions for all tables and indexes
- `database_data.sql` - SQL INSERT statements for the data from rawdatabase2.json
- `gemspider_database.sql` - Complete database file with both schema and data

### Conversion Tools
- `json_to_sql_converter.py` - Python script to convert JSON data to SQL INSERT statements

## Database Schema

The database consists of 4 main tables:

### 1. users
Stores wallet holder information and user details.
- `id` (PRIMARY KEY)
- `wallet_address` (UNIQUE)
- `username`
- `email` (UNIQUE)
- `created_at`, `updated_at`
- `status` (active/inactive/suspended)

### 2. transactions
Records all token purchase transactions.
- `id` (PRIMARY KEY)
- `user_id` (FOREIGN KEY)
- `transaction_hash` (UNIQUE)
- `from_address`, `to_address`
- `ton_amount`, `spider_amount`
- `exchange_rate`
- `transaction_type` (purchase/transfer/refund)
- `status` (pending/completed/failed/cancelled)
- `created_at`, `confirmed_at`

### 3. balances
Current wallet balances for users.
- `id` (PRIMARY KEY)
- `user_id` (FOREIGN KEY, UNIQUE)
- `wallet_address` (UNIQUE)
- `ton_balance`, `spider_balance`
- `last_updated`

### 4. presale_config
Configuration settings for the token presale.
- `id` (PRIMARY KEY)
- `token_name`, `token_symbol`
- `contract_address`, `receiver_address`
- `exchange_rate`
- `min_purchase`, `max_purchase`
- `total_supply`, `sold_amount`
- `presale_start`, `presale_end`
- `status`, `created_at`, `updated_at`

## Usage

### Setting up the database

1. **Using the complete database file:**
   ```bash
   sqlite3 gemspider.db < gemspider_database.sql
   ```

2. **Using separate schema and data files:**
   ```bash
   sqlite3 gemspider.db < database_schema.sql
   sqlite3 gemspider.db < database_data.sql
   ```

### Converting JSON to SQL

Use the Python converter script:

```bash
python3 json_to_sql_converter.py rawdatabase2.json output.sql
```

### Verifying the database

After creating the database, you can verify it with these queries:

```sql
-- Check record counts
SELECT 'Users:' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Transactions:', COUNT(*) FROM transactions
UNION ALL
SELECT 'Balances:', COUNT(*) FROM balances
UNION ALL
SELECT 'Presale Config:', COUNT(*) FROM presale_config;

-- Check data relationships
SELECT u.username, u.wallet_address, b.ton_balance, b.spider_balance 
FROM users u 
JOIN balances b ON u.id = b.user_id;
```

## Data Structure Mapping

The conversion from JSON to SQL follows this mapping:

| JSON Array | SQL Table | Description |
|------------|-----------|-------------|
| `users` | `users` | User accounts and wallet information |
| `transactions` | `transactions` | Token purchase transactions |
| `balances` | `balances` | Current wallet balances |
| `presale_config` | `presale_config` | Presale configuration settings |

## Token Information

- **Token Name:** SPIDER
- **Token Symbol:** SPIDER  
- **Exchange Rate:** 0.02 TON = 1 SPIDER
- **Contract Address:** EQBUMjg7ROfjh_ou3Lz1lpNrTJN59h2S-Wm-ZPsWWVzn-xc9
- **Receiver Address:** UQAVhdnM_-BLbS6W4b1BF5UyGWuIapjXRZjNJjfve7StCqST

## Notes

- All decimal amounts use DECIMAL(18, 9) precision to handle cryptocurrency values accurately
- Indexes are created on frequently queried columns for performance
- Foreign key relationships maintain data integrity
- Check constraints ensure valid enum values for status fields