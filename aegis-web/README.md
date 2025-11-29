# Aegis K3 Dashboard

Admin dashboard web application for K3 (Workplace Safety & Health) system built with Next.js 14, TypeScript, TailwindCSS, and shadcn/ui.

## Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: TailwindCSS
- **UI Components**: shadcn/ui
- **Data Fetching**: React Query (TanStack Query)
- **HTTP Client**: Axios
- **Charts**: Recharts
- **Icons**: Lucide Icons

## Features

### Authentication
- Login page with JWT authentication
- Protected routes
- Token refresh mechanism
- Demo mode for testing

### Dashboard
- Overview cards (inspections, incidents, permits)
- Monthly incident chart
- Safe/Unsafe inspection pie chart
- Recent activity feed

### Inspeksi (Inspections)
- List table with status filter
- Detail view with photo, location, description
- Editable status update

### Insiden (Incidents)
- List table with severity and status filters
- Detail view with investigation status
- Root cause analysis
- Corrective and preventive actions

### Permit to Work
- List with type and status filters
- Detail page with approve/reject functionality
- Hazard identification
- Safety precautions

### Users Management
- User list with role filter
- Add new users
- Role-based access: admin, supervisor, safety_officer, worker

## Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn

### Installation

```bash
# Navigate to the project directory
cd aegis-web

# Install dependencies
npm install

# Start development server
npm run dev
```

### Environment Variables

Create a `.env.local` file in the root directory:

```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
NEXT_PUBLIC_APP_NAME=Aegis K3 Dashboard
```

### Build for Production

```bash
npm run build
npm start
```

## Project Structure

```
aegis-web/
├── src/
│   ├── app/                    # Next.js App Router pages
│   │   ├── layout.tsx         # Root layout
│   │   ├── page.tsx           # Dashboard home
│   │   ├── login/             # Login page
│   │   ├── inspeksi/          # Inspection pages
│   │   ├── incident/          # Incident pages
│   │   ├── permit/            # Permit pages
│   │   └── users/             # User management
│   ├── components/
│   │   ├── ui/                # shadcn/ui components
│   │   ├── charts/            # Chart components
│   │   ├── sidebar.tsx        # Sidebar navigation
│   │   ├── topbar.tsx         # Top navigation bar
│   │   └── data-table.tsx     # Reusable data table
│   ├── lib/
│   │   ├── utils.ts           # Utility functions
│   │   ├── axios.ts           # Axios instance & interceptors
│   │   └── auth.ts            # Auth helper functions
│   ├── hooks/
│   │   ├── useAuth.ts         # Authentication hook
│   │   ├── useApi.ts          # API hooks with React Query
│   │   └── useToast.ts        # Toast notifications
│   └── types/                 # TypeScript type definitions
├── public/                    # Static assets
├── tailwind.config.ts        # Tailwind configuration
├── next.config.js            # Next.js configuration
└── package.json
```

## API Integration

The application expects a backend API (aegis-api) with the following endpoints:

### Authentication
- `POST /auth/login` - User login
- `POST /auth/logout` - User logout
- `POST /auth/refresh` - Refresh token
- `GET /auth/me` - Get current user

### Dashboard
- `GET /dashboard/stats` - Dashboard statistics
- `GET /dashboard/incidents-chart` - Incident chart data
- `GET /dashboard/inspeksi-chart` - Inspection chart data

### Inspections
- `GET /inspeksi` - List inspections
- `GET /inspeksi/:id` - Get inspection detail
- `POST /inspeksi` - Create inspection
- `PATCH /inspeksi/:id` - Update inspection
- `DELETE /inspeksi/:id` - Delete inspection

### Incidents
- `GET /incidents` - List incidents
- `GET /incidents/:id` - Get incident detail
- `POST /incidents` - Create incident
- `PATCH /incidents/:id` - Update incident
- `DELETE /incidents/:id` - Delete incident

### Permits
- `GET /permits` - List permits
- `GET /permits/:id` - Get permit detail
- `POST /permits` - Create permit
- `PATCH /permits/:id` - Update permit
- `POST /permits/:id/approve` - Approve/reject permit
- `DELETE /permits/:id` - Delete permit

### Users
- `GET /users` - List users
- `GET /users/:id` - Get user detail
- `POST /users` - Create user
- `PATCH /users/:id` - Update user
- `DELETE /users/:id` - Delete user

## Demo Mode

The application includes a demo mode that works without a backend. Click "Masuk dengan Akun Demo" on the login page to access the dashboard with mock data.

## License

MIT License

