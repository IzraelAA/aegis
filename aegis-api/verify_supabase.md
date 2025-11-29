# Verifikasi Supabase Connection

## Masalah: Hostname tidak bisa di-resolve

Error: `could not translate host name "db.zmzrssuzjmiiucchldxe.supabase.co"`

## Langkah Verifikasi:

### 1. Cek Status Project di Supabase Dashboard

1. Buka https://supabase.com/dashboard
2. Login ke akun Anda
3. Pilih project `zmzrssuzjmiiucchldxe` (atau project yang sesuai)
4. Pastikan:
   - ✅ Project status: **Active** (bukan Paused)
   - ✅ Database status: **Ready** (bukan Provisioning)
   - ⏱️ Jika masih "Provisioning", tunggu 1-2 menit

### 2. Ambil Connection String yang Benar

1. Di Supabase Dashboard, buka **Settings** > **Database**
2. Scroll ke bagian **Connection string**
3. Pilih tab **URI**
4. Copy connection string lengkap
5. Format yang benar:
   ```
   postgresql://postgres.[PROJECT-REF]:[YOUR-PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   ```
   ATAU
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```

### 3. Update .env File

Ganti `DATABASE_URL` di file `.env` dengan connection string yang di-copy dari dashboard.

**Untuk password dengan karakter `@`, gunakan URL-encoding:**
- Password: `@Izrael190799`
- URL-encoded: `%40Izrael190799`

**Contoh .env:**
```env
DATABASE_URL=postgresql://postgres:%40Izrael190799@db.zmzrssuzjmiiucchldxe.supabase.co:5432/postgres
```

### 4. Test Connection

```bash
cd aegis-api
source venv/bin/activate
python3 test_connection.py
```

### 5. Alternatif: Gunakan Connection Pooler

Jika direct connection tidak bekerja, coba Connection Pooler:

1. Di Supabase Dashboard > Settings > Database
2. Pilih tab **Connection pooling**
3. Copy **Session mode** connection string
4. Update `.env` dengan connection string tersebut

### 6. Troubleshooting

**Jika masih error:**

1. **Cek Internet Connection**
   ```bash
   ping google.com
   ```

2. **Cek DNS**
   ```bash
   nslookup db.zmzrssuzjmiiucchldxe.supabase.co
   ```

3. **Coba Connection Pooler URL**
   - Biasanya lebih reliable
   - Format: `pooler.supabase.com:6543`

4. **Verifikasi Project Reference**
   - Pastikan project reference di connection string sesuai dengan project Anda
   - Bisa dilihat di Settings > General > Reference ID

5. **Cek Firewall/Network**
   - Pastikan port 5432 atau 6543 tidak di-block
   - Coba dari network lain (mobile hotspot)

### 7. Test dengan psql (jika terinstall)

```bash
psql "postgresql://postgres:%40Izrael190799@db.zmzrssuzjmiiucchldxe.supabase.co:5432/postgres"
```

## Quick Checklist

- [ ] Project status: Active
- [ ] Database status: Ready
- [ ] Connection string di-copy dari dashboard (bukan manual)
- [ ] Password di-URL-encode jika mengandung karakter khusus
- [ ] Internet connection aktif
- [ ] File .env sudah di-update dengan connection string yang benar

## Next Steps

Setelah connection berhasil:
1. Run migration: `alembic upgrade head`
2. Test API: `uvicorn app.main:app --reload`

