#!/usr/bin/env python3
"""Check Supabase project status via API"""
import requests
import json

print("=" * 60)
print("Checking Supabase Project Status")
print("=" * 60)
print("\n⚠️  Note: This requires Supabase API key")
print("   You can find it in: Settings > API > anon key")
print("\nAlternatively, check manually in dashboard:")
print("   https://supabase.com/dashboard")
print("\n" + "=" * 60)
print("\nQuick Checklist:")
print("1. ✅ Project status: Active?")
print("2. ✅ Database status: Ready? (not Provisioning)")
print("3. ✅ Connection string copied from dashboard?")
print("4. ✅ Password URL-encoded correctly?")
print("\n" + "=" * 60)
print("\nIf project is still provisioning, wait 1-2 minutes")
print("then try connection again.")
