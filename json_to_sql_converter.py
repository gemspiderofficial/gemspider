#!/usr/bin/env python3
"""
JSON to SQL Converter for GemSpider Database
Converts rawdatabase2.json to SQL format
"""

import json
import sys
from datetime import datetime

def convert_json_to_sql(json_file_path, output_file_path=None):
    """
    Convert JSON data to SQL INSERT statements
    """
    try:
        with open(json_file_path, 'r') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: File {json_file_path} not found")
        return False
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON format - {e}")
        return False

    if output_file_path is None:
        output_file_path = json_file_path.replace('.json', '_converted.sql')

    sql_statements = []
    
    # Add header comment
    sql_statements.append("-- GemSpider Database - Converted from JSON")
    sql_statements.append(f"-- Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    sql_statements.append("")

    # Convert users
    if 'users' in data:
        sql_statements.append("-- Insert users data")
        for user in data['users']:
            sql = f"""INSERT INTO users (id, wallet_address, username, email, created_at, updated_at, status) VALUES
({user['id']}, '{user['wallet_address']}', '{user['username']}', '{user['email']}', '{user['created_at']}', '{user['updated_at']}', '{user['status']}');"""
            sql_statements.append(sql)
        sql_statements.append("")

    # Convert transactions
    if 'transactions' in data:
        sql_statements.append("-- Insert transactions data")
        for transaction in data['transactions']:
            confirmed_at = f"'{transaction['confirmed_at']}'" if transaction['confirmed_at'] else 'NULL'
            sql = f"""INSERT INTO transactions (id, user_id, transaction_hash, from_address, to_address, ton_amount, spider_amount, exchange_rate, transaction_type, status, created_at, confirmed_at) VALUES
({transaction['id']}, {transaction['user_id']}, '{transaction['transaction_hash']}', '{transaction['from_address']}', '{transaction['to_address']}', {transaction['ton_amount']}, {transaction['spider_amount']}, {transaction['exchange_rate']}, '{transaction['transaction_type']}', '{transaction['status']}', '{transaction['created_at']}', {confirmed_at});"""
            sql_statements.append(sql)
        sql_statements.append("")

    # Convert balances
    if 'balances' in data:
        sql_statements.append("-- Insert balances data")
        for balance in data['balances']:
            sql = f"""INSERT INTO balances (id, user_id, wallet_address, ton_balance, spider_balance, last_updated) VALUES
({balance['id']}, {balance['user_id']}, '{balance['wallet_address']}', {balance['ton_balance']}, {balance['spider_balance']}, '{balance['last_updated']}');"""
            sql_statements.append(sql)
        sql_statements.append("")

    # Convert presale_config
    if 'presale_config' in data:
        sql_statements.append("-- Insert presale configuration data")
        for config in data['presale_config']:
            sql = f"""INSERT INTO presale_config (id, token_name, token_symbol, contract_address, receiver_address, exchange_rate, min_purchase, max_purchase, total_supply, sold_amount, presale_start, presale_end, status, created_at, updated_at) VALUES
({config['id']}, '{config['token_name']}', '{config['token_symbol']}', '{config['contract_address']}', '{config['receiver_address']}', {config['exchange_rate']}, {config['min_purchase']}, {config['max_purchase']}, {config['total_supply']}, {config['sold_amount']}, '{config['presale_start']}', '{config['presale_end']}', '{config['status']}', '{config['created_at']}', '{config['updated_at']}');"""
            sql_statements.append(sql)

    # Write to output file
    try:
        with open(output_file_path, 'w') as f:
            f.write('\n'.join(sql_statements))
        print(f"Conversion successful! SQL file saved as: {output_file_path}")
        return True
    except Exception as e:
        print(f"Error writing to file: {e}")
        return False

def main():
    if len(sys.argv) < 2:
        print("Usage: python json_to_sql_converter.py <json_file> [output_file]")
        print("Example: python json_to_sql_converter.py rawdatabase2.json database_data_converted.sql")
        sys.exit(1)
    
    json_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    convert_json_to_sql(json_file, output_file)

if __name__ == "__main__":
    main()