# Quick Verification Checklist

## ✅ Checklist untuk Fix Connection Issue

### 1. Verifikasi di Supabase Dashboard
- [ ] Buka https://supabase.com/dashboard
- [ ] Login ke akun Anda
- [ ] Pilih project yang benar
- [ ] Cek **Project Status**: Harus "Active" (hijau) ✅
- [ ] Cek **Database Status**: Harus "Ready" (bukan "Provisioning") ✅

### 2. Ambil Connection String yang Benar
- [ ] Klik **Settings** → **Database**
- [ ] Scroll ke **"Connection string"** section
- [ ] Pilih tab **"URI"**
- [ ] **Copy connection string LENGKAP** (jangan ketik manual!)
- [ ] Format harus seperti:
  ```
  postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
  ```
  ATAU (Connection Pooler - lebih recommended):
  ```
  postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
  ```

### 3. Update .env File
- [ ] Buka file `.env` di folder `aegis-api`
- [ ] Ganti `DATABASE_URL` dengan connection string dari dashboard
- [ ] **PENTING**: Jika password mengandung `@`, URL-encode menjadi `%40`
  - Contoh: Password `@Izrael190799` → `%40Izrael190799`

### 4. Test Connection
```bash
cd aegis-api
source venv/bin/activate
python3 test_connection.py
```

### 5. Jika Masih Error

#### Option A: Coba Connection Pooler
1. Di dashboard: **Settings** → **Database** → **Connection pooling**
2. Copy **"Session mode"** connection string
3. Update `.env` dengan connection string tersebut
4. Test lagi

#### Option B: Verifikasi Project Reference
- Di dashboard: **Settings** → **General** → **Reference ID**
- Pastikan Reference ID di connection string sesuai dengan yang di dashboard

#### Option C: Tunggu Project Provisioning
- Jika project masih "Provisioning", tunggu 1-2 menit
- Refresh dashboard dan cek lagi status

## 🎯 Expected Result

Setelah semua checklist di atas, test connection harus menunjukkan:
```
✅ Connection successful!
Current Time: 2024-...
PostgreSQL Version: PostgreSQL ...
✅ Connection closed successfully!
```

## 📞 Still Not Working?

Jika setelah semua langkah di atas masih error:
1. Cek internet connection: `ping google.com`
2. Coba dari network lain (mobile hotspot)
3. Cek Supabase status: https://status.supabase.com
4. Contact Supabase support di Discord: https://discord.supabase.com
