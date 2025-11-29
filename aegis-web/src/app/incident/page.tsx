'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { DashboardLayout } from '@/components/dashboard-layout'
import { DataTable } from '@/components/data-table'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { useIncidentList, useIncidentStats } from '@/hooks/useApi'
import { Incident, IncidentSeverity, IncidentStatus } from '@/types'
import { ColumnDef } from '@tanstack/react-table'
import { formatDate, getStatusColor } from '@/lib/utils'
import {
  AlertTriangle,
  Plus,
  Eye,
  MoreHorizontal,
  MapPin,
  User,
  AlertCircle,
  AlertOctagon,
  CircleDot,
  Search,
  CheckCircle2,
  Clock,
} from 'lucide-react'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import Link from 'next/link'

// Mock data for demo
const mockIncidents: Incident[] = [
  {
    id: '1',
    title: 'Tumpahan Bahan Kimia',
    description: 'Terjadi tumpahan bahan kimia di area lab',
    location: 'Laboratorium Kimia',
    severity: 'major',
    status: 'investigating',
    date: '2024-01-15',
    reporter: { id: '1', name: 'Ahmad Rizki' },
    department: 'R&D',
    createdAt: '2024-01-15T08:00:00Z',
    updatedAt: '2024-01-15T09:00:00Z',
  },
  {
    id: '2',
    title: 'Near Miss - Forklift',
    description: 'Hampir terjadi tabrakan forklift dengan pekerja',
    location: 'Gudang B',
    severity: 'near-miss',
    status: 'closed',
    date: '2024-01-14',
    reporter: { id: '2', name: 'Budi Santoso' },
    department: 'Logistik',
    createdAt: '2024-01-14T10:30:00Z',
    updatedAt: '2024-01-14T15:00:00Z',
  },
  {
    id: '3',
    title: 'Luka Ringan - Tergores',
    description: 'Pekerja mengalami luka gores pada tangan',
    location: 'Workshop',
    severity: 'minor',
    status: 'closed',
    date: '2024-01-13',
    reporter: { id: '3', name: 'Siti Rahayu' },
    department: 'Produksi',
    injuredPersons: 1,
    createdAt: '2024-01-13T14:00:00Z',
    updatedAt: '2024-01-13T16:00:00Z',
  },
  {
    id: '4',
    title: 'Kebocoran Gas',
    description: 'Terdeteksi kebocoran gas pada pipa distribusi',
    location: 'Area Produksi',
    severity: 'major',
    status: 'open',
    date: '2024-01-12',
    reporter: { id: '4', name: 'Dian Permata' },
    department: 'Maintenance',
    createdAt: '2024-01-12T08:00:00Z',
    updatedAt: '2024-01-12T08:30:00Z',
  },
  {
    id: '5',
    title: 'Lantai Licin',
    description: 'Kondisi lantai licin setelah pembersihan',
    location: 'Koridor Utama',
    severity: 'near-miss',
    status: 'closed',
    date: '2024-01-11',
    reporter: { id: '5', name: 'Eko Prasetyo' },
    department: 'Admin',
    createdAt: '2024-01-11T09:00:00Z',
    updatedAt: '2024-01-11T11:00:00Z',
  },
]

const columns: ColumnDef<Incident>[] = [
  {
    accessorKey: 'title',
    header: 'Judul Insiden',
    cell: ({ row }) => (
      <div className="flex flex-col">
        <span className="font-medium text-slate-900 dark:text-white">
          {row.original.title}
        </span>
        <span className="text-xs text-slate-500 line-clamp-1">
          {row.original.description}
        </span>
      </div>
    ),
  },
  {
    accessorKey: 'location',
    header: 'Lokasi',
    cell: ({ row }) => (
      <div className="flex items-center gap-2 text-slate-600 dark:text-slate-400">
        <MapPin className="h-4 w-4" />
        <span>{row.original.location}</span>
      </div>
    ),
  },
  {
    accessorKey: 'severity',
    header: 'Tingkat',
    cell: ({ row }) => {
      const severity = row.original.severity
      const severityLabels: Record<IncidentSeverity, string> = {
        minor: 'Minor',
        major: 'Major',
        'near-miss': 'Near Miss',
      }
      const severityIcons: Record<IncidentSeverity, React.ReactNode> = {
        minor: <AlertCircle className="h-3.5 w-3.5" />,
        major: <AlertOctagon className="h-3.5 w-3.5" />,
        'near-miss': <CircleDot className="h-3.5 w-3.5" />,
      }
      return (
        <Badge className={`${getStatusColor(severity)} flex items-center gap-1 w-fit`}>
          {severityIcons[severity]}
          {severityLabels[severity]}
        </Badge>
      )
    },
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.original.status
      const statusLabels: Record<IncidentStatus, string> = {
        open: 'Open',
        investigating: 'Investigasi',
        closed: 'Closed',
      }
      const statusIcons: Record<IncidentStatus, React.ReactNode> = {
        open: <AlertTriangle className="h-3.5 w-3.5" />,
        investigating: <Search className="h-3.5 w-3.5" />,
        closed: <CheckCircle2 className="h-3.5 w-3.5" />,
      }
      return (
        <Badge className={`${getStatusColor(status)} flex items-center gap-1 w-fit`}>
          {statusIcons[status]}
          {statusLabels[status]}
        </Badge>
      )
    },
  },
  {
    accessorKey: 'date',
    header: 'Tanggal',
    cell: ({ row }) => (
      <span className="text-slate-600 dark:text-slate-400">
        {formatDate(row.original.date)}
      </span>
    ),
  },
  {
    id: 'actions',
    cell: ({ row }) => (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon" className="h-8 w-8">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuLabel>Aksi</DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem asChild>
            <Link href={`/incident/${row.original.id}`}>
              <Eye className="mr-2 h-4 w-4" />
              Lihat Detail
            </Link>
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
]

export default function IncidentPage() {
  const [severityFilter, setSeverityFilter] = useState<string>('all')
  const [statusFilter, setStatusFilter] = useState<string>('all')
  const router = useRouter()

  const { data, isLoading } = useIncidentList({
    ...(severityFilter !== 'all' && { severity: severityFilter }),
    ...(statusFilter !== 'all' && { status: statusFilter }),
  })
  const { data: stats } = useIncidentStats()

  // Use mock data if API fails
  const incidentData = data?.data || mockIncidents
  let filteredData = incidentData

  if (severityFilter !== 'all') {
    filteredData = filteredData.filter(i => i.severity === severityFilter)
  }
  if (statusFilter !== 'all') {
    filteredData = filteredData.filter(i => i.status === statusFilter)
  }

  const mockStats = {
    total: 89,
    minor: 35,
    major: 12,
    nearMiss: 42,
    open: 8,
    investigating: 4,
    closed: 77,
  }

  const incidentStats = stats || mockStats

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <h1 className="text-3xl font-bold text-slate-900 dark:text-white flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-rose-500 to-red-500 text-white">
                <AlertTriangle className="h-5 w-5" />
              </div>
              Insiden
            </h1>
            <p className="text-slate-500 dark:text-slate-400 mt-1">
              Kelola dan pantau laporan insiden keselamatan kerja
            </p>
          </div>
          <Button className="bg-gradient-to-r from-rose-500 to-red-500 hover:from-rose-600 hover:to-red-600 text-white shadow-lg shadow-rose-500/25">
            <Plus className="mr-2 h-4 w-4" />
            Laporkan Insiden
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card className="bg-gradient-to-br from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Total Insiden</p>
                  <p className="text-3xl font-bold text-slate-900 dark:text-white">{incidentStats.total}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-100 dark:bg-slate-700">
                  <AlertTriangle className="h-6 w-6 text-slate-600 dark:text-slate-300" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-amber-50 to-amber-50/50 dark:from-amber-900/20 dark:to-amber-900/10 border-amber-100 dark:border-amber-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Minor</p>
                  <p className="text-3xl font-bold text-amber-600 dark:text-amber-400">{incidentStats.minor}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-100 dark:bg-amber-800/50">
                  <AlertCircle className="h-6 w-6 text-amber-600 dark:text-amber-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-rose-50 to-rose-50/50 dark:from-rose-900/20 dark:to-rose-900/10 border-rose-100 dark:border-rose-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Major</p>
                  <p className="text-3xl font-bold text-rose-600 dark:text-rose-400">{incidentStats.major}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-rose-100 dark:bg-rose-800/50">
                  <AlertOctagon className="h-6 w-6 text-rose-600 dark:text-rose-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-blue-50 to-blue-50/50 dark:from-blue-900/20 dark:to-blue-900/10 border-blue-100 dark:border-blue-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Near Miss</p>
                  <p className="text-3xl font-bold text-blue-600 dark:text-blue-400">{incidentStats.nearMiss}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100 dark:bg-blue-800/50">
                  <CircleDot className="h-6 w-6 text-blue-600 dark:text-blue-400" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Quick Stats */}
        <div className="grid gap-4 md:grid-cols-3">
          <Card className="bg-gradient-to-br from-amber-500/10 to-amber-500/5">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-amber-500/20 text-amber-500">
                <Clock className="h-5 w-5" />
              </div>
              <div>
                <p className="text-2xl font-bold text-amber-600">{incidentStats.open}</p>
                <p className="text-sm text-slate-500">Open</p>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-purple-500/10 to-purple-500/5">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-purple-500/20 text-purple-500">
                <Search className="h-5 w-5" />
              </div>
              <div>
                <p className="text-2xl font-bold text-purple-600">{incidentStats.investigating}</p>
                <p className="text-sm text-slate-500">Investigasi</p>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-emerald-500/10 to-emerald-500/5">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-emerald-500/20 text-emerald-500">
                <CheckCircle2 className="h-5 w-5" />
              </div>
              <div>
                <p className="text-2xl font-bold text-emerald-600">{incidentStats.closed}</p>
                <p className="text-sm text-slate-500">Closed</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Table */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Insiden</CardTitle>
            <CardDescription>
              Lihat semua laporan insiden keselamatan kerja
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap items-center gap-4 mb-6">
              <Select value={severityFilter} onValueChange={setSeverityFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Tingkat" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Tingkat</SelectItem>
                  <SelectItem value="minor">Minor</SelectItem>
                  <SelectItem value="major">Major</SelectItem>
                  <SelectItem value="near-miss">Near Miss</SelectItem>
                </SelectContent>
              </Select>
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Status</SelectItem>
                  <SelectItem value="open">Open</SelectItem>
                  <SelectItem value="investigating">Investigasi</SelectItem>
                  <SelectItem value="closed">Closed</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <DataTable
              columns={columns}
              data={filteredData}
              searchKey="title"
              searchPlaceholder="Cari insiden..."
              isLoading={isLoading}
            />
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}

