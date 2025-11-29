#!/usr/bin/env python3
"""Test Supabase PostgreSQL Connection"""
import psycopg2
from dotenv import load_dotenv
import os
from urllib.parse import urlparse

# Load environment variables from .env
load_dotenv()

print("=" * 60)
print("Testing Supabase Connection")
print("=" * 60)

# Method 1: Using DATABASE_URL
print("\n1. Testing with DATABASE_URL...")
DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL:
    print(f"   DATABASE_URL found: {DATABASE_URL[:50]}...")
    try:
        # Parse connection string
        parsed = urlparse(DATABASE_URL)
        
        connection = psycopg2.connect(
            user=parsed.username,
            password=parsed.password,
            host=parsed.hostname,
            port=parsed.port,
            dbname=parsed.path[1:]  # Remove leading '/'
        )
        print("   ✅ Connection successful!")
        
        # Test query
        cursor = connection.cursor()
        cursor.execute("SELECT NOW(), version();")
        result = cursor.fetchone()
        print(f"   Current Time: {result[0]}")
        print(f"   PostgreSQL Version: {result[1][:50]}...")
        
        cursor.close()
        connection.close()
        print("   ✅ Connection closed successfully!")
        
    except Exception as e:
        print(f"   ❌ Connection failed: {e}")
else:
    print("   ⚠️  DATABASE_URL not found in .env")

# Method 2: Using individual variables (if provided)
print("\n2. Testing with individual variables...")
USER = os.getenv("user") or os.getenv("DB_USER")
PASSWORD = os.getenv("password") or os.getenv("DB_PASSWORD")
HOST = os.getenv("host") or os.getenv("DB_HOST")
PORT = os.getenv("port") or os.getenv("DB_PORT") or "5432"
DBNAME = os.getenv("dbname") or os.getenv("DB_NAME") or "postgres"

if all([USER, PASSWORD, HOST]):
    print(f"   Host: {HOST}")
    print(f"   Port: {PORT}")
    print(f"   Database: {DBNAME}")
    try:
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        print("   ✅ Connection successful!")
        
        cursor = connection.cursor()
        cursor.execute("SELECT NOW();")
        result = cursor.fetchone()
        print(f"   Current Time: {result[0]}")
        
        cursor.close()
        connection.close()
        print("   ✅ Connection closed successfully!")
        
    except Exception as e:
        print(f"   ❌ Connection failed: {e}")
else:
    print("   ⚠️  Individual variables not found in .env")
    print("   (This is OK if using DATABASE_URL)")

print("\n" + "=" * 60)
print("Test completed!")
print("=" * 60)

