# Quick Fix: Supabase Connection Issue

## Problem
```
❌ Connection failed: could not translate host name 
"db.zmzrssuzjmiiucchldxe.supabase.co" to address
```

## Most Common Causes

### 1. Project Not Fully Provisioned ⏱️
**Solution:** Wait 1-2 minutes after creating project, then check dashboard

### 2. Wrong Connection String 📋
**Solution:** Copy connection string directly from Supabase dashboard

### 3. Project Paused or Inactive ⚠️
**Solution:** Check project status in dashboard, make sure it's "Active"

## Step-by-Step Fix

### Step 1: Verify in Dashboard
1. Go to https://supabase.com/dashboard
2. Select your project
3. Check:
   - **Project Status**: Should be "Active" (green)
   - **Database Status**: Should be "Ready" (not "Provisioning")

### Step 2: Get Correct Connection String
1. In dashboard: **Settings** → **Database**
2. Scroll to **"Connection string"** section
3. Click tab **"URI"**
4. **Copy the ENTIRE connection string** (don't type manually)
5. It should look like:
   ```
   postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   ```
   OR
   ```
   postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```

### Step 3: Update .env File
Replace `DATABASE_URL` in `.env` with the connection string from dashboard.

**Important:** If password contains special characters like `@`, URL-encode them:
- `@` → `%40`
- `#` → `%23`
- `%` → `%25`
- etc.

**Example:**
```env
# Password: @Izrael190799
# URL-encoded: %40Izrael190799

DATABASE_URL=postgresql://postgres:%40Izrael190799@db.zmzrssuzjmiiucchldxe.supabase.co:5432/postgres
```

### Step 4: Test Connection
```bash
cd aegis-api
source venv/bin/activate
python3 test_connection.py
```

## Alternative: Use Connection Pooler

If direct connection doesn't work, try Connection Pooler (more reliable):

1. In dashboard: **Settings** → **Database** → **Connection pooling**
2. Copy **"Session mode"** connection string
3. Update `.env` with that connection string
4. Test again

## Still Not Working?

### Check Internet Connection
```bash
ping google.com
ping supabase.com
```

### Try Different DNS
```bash
# Use Google DNS
nslookup db.zmzrssuzjmiiucchldxe.supabase.co 8.8.8.8
```

### Verify Project Reference
- Check in dashboard: **Settings** → **General** → **Reference ID**
- Make sure it matches the one in connection string

### Contact Support
If still not working after all checks:
- Supabase Discord: https://discord.supabase.com
- Supabase GitHub: https://github.com/supabase/supabase

## Success Indicators

When connection works, you should see:
```
✅ Connection successful!
Current Time: 2024-...
PostgreSQL Version: PostgreSQL ...
✅ Connection closed successfully!
```

