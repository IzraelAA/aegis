# AEGIS K3 API

A comprehensive backend API for Occupational Health & Safety (K3 - Keselamatan & Kesehatan Kerja) management system built with FastAPI.

## Features

- **Authentication**: JWT-based authentication with access and refresh tokens
- **Role-Based Access Control**: User, Supervisor, Safety Officer, Admin roles
- **Inspections**: Create and manage safety inspections
- **Incidents**: Report and track incident investigations
- **Permits (PTW)**: Permit to Work management with approval workflow

## Tech Stack

- **Framework**: FastAPI
- **Language**: Python 3.10+
- **Database**: PostgreSQL
- **ORM**: SQLAlchemy 2.0
- **Migrations**: Alembic
- **Authentication**: JWT (python-jose)
- **Password Hashing**: bcrypt (passlib)

## Project Structure

```
aegis-api/
├── app/
│   ├── core/
│   │   ├── config.py       # Application configuration
│   │   ├── database.py     # Database connection
│   │   └── security.py     # JWT & password utilities
│   ├── models/
│   │   ├── user.py         # User model
│   │   ├── inspection.py   # Inspection model
│   │   ├── incident.py     # Incident model
│   │   └── permit.py       # Permit model
│   ├── schemas/
│   │   ├── auth.py         # Authentication schemas
│   │   ├── user.py         # User schemas
│   │   ├── inspection.py   # Inspection schemas
│   │   ├── incident.py     # Incident schemas
│   │   └── permit.py       # Permit schemas
│   ├── repositories/
│   │   ├── base_repository.py
│   │   ├── user_repository.py
│   │   ├── inspection_repository.py
│   │   ├── incident_repository.py
│   │   └── permit_repository.py
│   ├── services/
│   │   ├── auth_service.py
│   │   ├── user_service.py
│   │   ├── inspection_service.py
│   │   ├── incident_service.py
│   │   └── permit_service.py
│   ├── routers/
│   │   ├── auth_router.py
│   │   ├── user_router.py
│   │   ├── inspection_router.py
│   │   ├── incident_router.py
│   │   └── permit_router.py
│   └── main.py             # Application entry point
├── alembic/
│   ├── versions/           # Migration files
│   ├── env.py
│   └── script.py.mako
├── alembic.ini
├── requirements.txt
├── .env.example
└── README.md
```

## Installation

### 1. Clone the repository

```bash
cd aegis-api
```

### 2. Create virtual environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure environment

```bash
cp env.example .env
```

Edit `.env` with your configuration.

#### Option A: Using Supabase (Recommended for Production)

1. **Create Supabase Project:**
   - Go to https://supabase.com
   - Sign up / Login
   - Click "New Project"
   - Fill in project details and wait for provisioning (1-2 minutes)

2. **Get Connection String:**
   - In Supabase Dashboard: **Settings** → **Database**
   - Scroll to **"Connection string"** section
   - Select tab **"URI"**
   - Copy the connection string
   - **Important:** If password contains special characters (like `@`), URL-encode them:
     - `@` → `%40`
     - `#` → `%23`
     - `%` → `%25`

3. **Update `.env` file:**

```env
# Supabase PostgreSQL Connection
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# Or use Connection Pooler (more reliable):
# DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres

SECRET_KEY=your-super-secret-key-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7
APP_NAME=AEGIS K3 API
DEBUG=True
```

**Example with URL-encoded password:**
```env
# Password: @Izrael190799 → URL-encoded: %40Izrael190799
DATABASE_URL=postgresql://postgres:%40Izrael190799@db.zmzrssuzjmiiucchldxe.supabase.co:5432/postgres
```

#### Option B: Using Local PostgreSQL

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/aegis_k3
SECRET_KEY=your-super-secret-key-change-this-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7
APP_NAME=AEGIS K3 API
DEBUG=True
```

### 5. Setup Database

#### If using Supabase:
- Database is already created and ready
- Just make sure project status is **"Active"** in Supabase dashboard
- Skip to step 6 (Run migrations)

#### If using Local PostgreSQL:

```bash
createdb aegis_k3
```

Or using psql:

```sql
CREATE DATABASE aegis_k3;
```

### 6. Test Database Connection (Optional)

Test your database connection:

```bash
source venv/bin/activate
python3 test_connection.py
```

You should see:
```
✅ Connection successful!
Current Time: ...
PostgreSQL Version: ...
```

### 7. Run migrations

```bash
source venv/bin/activate

# If this is the first time, generate initial migration
alembic revision --autogenerate -m "Initial migration"

# Apply all migrations
alembic upgrade head
```

**Note:** If you're using Supabase and the migration for renaming fields to English already exists, just run:
```bash
alembic upgrade head
```

### 8. Run the server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Or:

```bash
python -m app.main
```

## API Documentation

Once the server is running, access the API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **OpenAPI JSON**: http://localhost:8000/openapi.json

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/login` | Login and get tokens |
| POST | `/api/v1/auth/refresh` | Refresh access token |

### Users

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| GET | `/api/v1/users/me` | Get current user profile | All |
| PUT | `/api/v1/users/me` | Update current user | All |
| GET | `/api/v1/users` | Get all users | Admin |
| POST | `/api/v1/users` | Create user | Admin |
| GET | `/api/v1/users/{id}` | Get user by ID | Admin |
| PUT | `/api/v1/users/{id}` | Update user | Admin/Owner |
| DELETE | `/api/v1/users/{id}` | Delete user | Admin |

### Inspections

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/api/v1/inspections` | Create inspection | All |
| GET | `/api/v1/inspections` | Get all inspections | All |
| GET | `/api/v1/inspections/my` | Get my inspections | All |
| GET | `/api/v1/inspections/{id}` | Get inspection by ID | All |
| PUT | `/api/v1/inspections/{id}` | Update inspection | Owner/Supervisor+ |
| PATCH | `/api/v1/inspections/{id}/status` | Update status | Supervisor+ |
| DELETE | `/api/v1/inspections/{id}` | Delete inspection | Admin |

### Incidents

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/api/v1/incidents` | Create incident | All |
| GET | `/api/v1/incidents` | Get all incidents | All |
| GET | `/api/v1/incidents/my` | Get my incidents | All |
| GET | `/api/v1/incidents/{id}` | Get incident by ID | All |
| PUT | `/api/v1/incidents/{id}` | Update incident | Owner/Safety Officer+ |
| PATCH | `/api/v1/incidents/{id}/investigation` | Update investigation | Safety Officer+ |
| DELETE | `/api/v1/incidents/{id}` | Delete incident | Admin |

### Permits (PTW)

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| POST | `/api/v1/permits` | Create permit | All |
| GET | `/api/v1/permits` | Get all permits | All |
| GET | `/api/v1/permits/my` | Get my permits | All |
| GET | `/api/v1/permits/pending` | Get pending permits | Supervisor+ |
| GET | `/api/v1/permits/{id}` | Get permit by ID | All |
| PUT | `/api/v1/permits/{id}` | Update permit | Owner/Admin |
| POST | `/api/v1/permits/{id}/approve` | Approve permit | Supervisor+ |
| POST | `/api/v1/permits/{id}/reject` | Reject permit | Supervisor+ |
| DELETE | `/api/v1/permits/{id}` | Delete permit | Admin |

## Testing with cURL

### Register a new user

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "username": "testuser",
    "password": "password123",
    "full_name": "Test User",
    "department": "Safety"
  }'
```

### Login

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Get profile (with token)

```bash
curl -X GET http://localhost:8000/api/v1/users/me \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Create an inspection

```bash
curl -X POST http://localhost:8000/api/v1/inspections \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "location": "Workshop A",
    "category": "Electrical Safety",
    "description": "Monthly electrical inspection",
    "status": "safe"
  }'
```

### Create an incident report

```bash
curl -X POST http://localhost:8000/api/v1/incidents \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Minor injury in Workshop",
    "description": "Worker cut finger while handling metal sheet",
    "location": "Workshop B",
    "incident_datetime": "2024-01-15T10:30:00",
    "category": "minor"
  }'
```

### Create a permit request

```bash
curl -X POST http://localhost:8000/api/v1/permits \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "permit_type": "hot_work",
    "description": "Welding work on pipe system",
    "location": "Building C, Floor 2",
    "start_date": "2024-01-20T08:00:00",
    "end_date": "2024-01-20T17:00:00"
  }'
```

### Approve a permit (as supervisor/safety officer)

```bash
curl -X POST http://localhost:8000/api/v1/permits/1/approve \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "approval_notes": "Approved. Ensure fire extinguisher is available."
  }'
```

### Refresh token

```bash
curl -X POST http://localhost:8000/api/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "YOUR_REFRESH_TOKEN"
  }'
```

## Role Permissions

| Role | Description |
|------|-------------|
| `user` | Basic access - can create inspections, incidents, permits |
| `supervisor` | Can update inspection status, approve/reject permits |
| `safety_officer` | Can manage incident investigations |
| `admin` | Full system access including user management |

## Supabase Setup & Troubleshooting

### Verifying Supabase Connection

If you're using Supabase and experiencing connection issues:

1. **Check Project Status:**
   - Go to https://supabase.com/dashboard
   - Ensure project status is **"Active"** (not Paused)
   - Ensure database status is **"Ready"** (not Provisioning)

2. **Test Connection:**
   ```bash
   source venv/bin/activate
   python3 test_connection.py
   ```

3. **Common Issues:**

   **Issue: Hostname cannot be resolved**
   - **Solution:** Wait 1-2 minutes after creating project, then verify in dashboard
   - **Solution:** Copy connection string directly from Supabase dashboard (don't type manually)

   **Issue: Password with special characters**
   - **Solution:** URL-encode special characters:
     - `@` → `%40`
     - `#` → `%23`
     - `%` → `%25`
   - Example: Password `@Izrael190799` becomes `%40Izrael190799`

   **Issue: Connection timeout**
   - **Solution:** Use Connection Pooler URL instead of direct connection
   - Get it from: Settings → Database → Connection pooling → Session mode

4. **Using Connection Pooler (Recommended):**
   
   Connection Pooler is more reliable for production:
   ```env
   DATABASE_URL=postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
   ```

### Supabase Free Tier Limits

- **Database Storage:** 500 MB
- **Database Size:** Sufficient for small to medium applications
- **Connection Limits:** 60 direct connections, unlimited via pooler
- **Backup:** Automatic daily backups

For more information, see: https://supabase.com/pricing

## Development

### Running tests

```bash
pytest
```

### Code formatting

```bash
black app/
isort app/
```

### Linting

```bash
flake8 app/
mypy app/
```

## License

MIT License

