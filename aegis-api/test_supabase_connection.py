#!/usr/bin/env python3
"""Test Supabase connection"""
import sys
import os
from urllib.parse import quote

# Test different connection string formats
password = "@Izrael190799"
host = "db.zmzrssuzjmiiucchldxe.supabase.co"

print("=" * 60)
print("Testing Supabase Connection")
print("=" * 60)
print(f"Host: {host}")
print(f"Password: {password}")
print()

# Format 1: URL encoded
encoded_pass = quote(password, safe='')
conn_str_1 = f"postgresql://postgres:{encoded_pass}@{host}:5432/postgres"
print("Format 1 (URL-encoded):")
print(conn_str_1)
print()

# Format 2: Direct (might work with psycopg2)
conn_str_2 = f"postgresql://postgres:{password}@{host}:5432/postgres"
print("Format 2 (Direct):")
print(conn_str_2)
print()

# Format 3: With connection pooling (Supabase recommended)
pooler_host = host.replace("db.", "aws-0-ap-southeast-1.pooler.")
conn_str_3 = f"postgresql://postgres.{host.split('.')[1]}:{encoded_pass}@{pooler_host}:6543/postgres"
print("Format 3 (Connection Pooler):")
print(conn_str_3)
print()

print("=" * 60)
print("Troubleshooting:")
print("1. Pastikan Supabase project sudah fully provisioned (cek di dashboard)")
print("2. Cek apakah connection string di Supabase dashboard sudah benar")
print("3. Pastikan internet connection aktif")
print("4. Coba gunakan Connection Pooler URL dari Supabase dashboard")
print("=" * 60)
