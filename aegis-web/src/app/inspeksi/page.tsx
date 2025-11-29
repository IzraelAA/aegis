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
import { useInspeksiList, useInspeksiStats } from '@/hooks/useApi'
import { Inspeksi, InspeksiStatus } from '@/types'
import { ColumnDef } from '@tanstack/react-table'
import { formatDate, getStatusColor } from '@/lib/utils'
import {
  ClipboardCheck,
  Plus,
  Eye,
  MoreHorizontal,
  CheckCircle2,
  XCircle,
  Clock,
  MapPin,
  User,
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
const mockInspeksi: Inspeksi[] = [
  {
    id: '1',
    title: 'Inspeksi Area Produksi',
    description: 'Pemeriksaan rutin area produksi',
    location: 'Gedung A - Lantai 1',
    status: 'safe',
    inspector: { id: '1', name: 'Ahmad Rizki' },
    department: 'Produksi',
    createdAt: '2024-01-15T08:00:00Z',
    updatedAt: '2024-01-15T08:00:00Z',
  },
  {
    id: '2',
    title: 'Inspeksi Gudang B',
    description: 'Pemeriksaan kondisi gudang penyimpanan',
    location: 'Gudang B',
    status: 'unsafe',
    inspector: { id: '2', name: 'Budi Santoso' },
    department: 'Logistik',
    findings: 'Ditemukan rak penyimpanan yang tidak stabil',
    createdAt: '2024-01-14T09:30:00Z',
    updatedAt: '2024-01-14T10:00:00Z',
  },
  {
    id: '3',
    title: 'Inspeksi Laboratorium',
    description: 'Pemeriksaan peralatan dan bahan kimia',
    location: 'Lab Kimia',
    status: 'pending',
    inspector: { id: '3', name: 'Siti Rahayu' },
    department: 'R&D',
    createdAt: '2024-01-14T14:00:00Z',
    updatedAt: '2024-01-14T14:00:00Z',
  },
  {
    id: '4',
    title: 'Inspeksi Kantor Utama',
    description: 'Pemeriksaan jalur evakuasi',
    location: 'Gedung Utama',
    status: 'safe',
    inspector: { id: '4', name: 'Dian Permata' },
    department: 'Admin',
    createdAt: '2024-01-13T11:00:00Z',
    updatedAt: '2024-01-13T11:30:00Z',
  },
  {
    id: '5',
    title: 'Inspeksi Workshop',
    description: 'Pemeriksaan alat dan mesin workshop',
    location: 'Workshop',
    status: 'unsafe',
    inspector: { id: '5', name: 'Eko Prasetyo' },
    department: 'Maintenance',
    findings: 'Beberapa mesin tidak memiliki guard yang memadai',
    createdAt: '2024-01-12T08:30:00Z',
    updatedAt: '2024-01-12T09:00:00Z',
  },
]

const columns: ColumnDef<Inspeksi>[] = [
  {
    accessorKey: 'title',
    header: 'Judul Inspeksi',
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
    accessorKey: 'inspector.name',
    header: 'Inspektor',
    cell: ({ row }) => (
      <div className="flex items-center gap-2 text-slate-600 dark:text-slate-400">
        <User className="h-4 w-4" />
        <span>{row.original.inspector.name}</span>
      </div>
    ),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.original.status
      const statusLabels: Record<InspeksiStatus, string> = {
        safe: 'Aman',
        unsafe: 'Tidak Aman',
        pending: 'Pending',
      }
      const statusIcons: Record<InspeksiStatus, React.ReactNode> = {
        safe: <CheckCircle2 className="h-3.5 w-3.5" />,
        unsafe: <XCircle className="h-3.5 w-3.5" />,
        pending: <Clock className="h-3.5 w-3.5" />,
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
    accessorKey: 'createdAt',
    header: 'Tanggal',
    cell: ({ row }) => (
      <span className="text-slate-600 dark:text-slate-400">
        {formatDate(row.original.createdAt)}
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
            <Link href={`/inspeksi/${row.original.id}`}>
              <Eye className="mr-2 h-4 w-4" />
              Lihat Detail
            </Link>
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
]

export default function InspeksiPage() {
  const [statusFilter, setStatusFilter] = useState<string>('all')
  const router = useRouter()

  const { data, isLoading } = useInspeksiList(
    statusFilter !== 'all' ? { status: statusFilter } : undefined
  )
  const { data: stats } = useInspeksiStats()

  // Use mock data if API fails
  const inspeksiData = data?.data || mockInspeksi
  const filteredData = statusFilter === 'all' 
    ? inspeksiData 
    : inspeksiData.filter(i => i.status === statusFilter)

  const mockStats = {
    total: 216,
    safe: 156,
    unsafe: 42,
    pending: 18,
  }

  const inspeksiStats = stats || mockStats

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <h1 className="text-3xl font-bold text-slate-900 dark:text-white flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-teal-500 to-emerald-500 text-white">
                <ClipboardCheck className="h-5 w-5" />
              </div>
              Inspeksi
            </h1>
            <p className="text-slate-500 dark:text-slate-400 mt-1">
              Kelola dan pantau hasil inspeksi keselamatan kerja
            </p>
          </div>
          <Button className="bg-gradient-to-r from-teal-500 to-emerald-500 hover:from-teal-600 hover:to-emerald-600 text-white shadow-lg shadow-teal-500/25">
            <Plus className="mr-2 h-4 w-4" />
            Tambah Inspeksi
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-4">
          <Card className="bg-gradient-to-br from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Total Inspeksi</p>
                  <p className="text-3xl font-bold text-slate-900 dark:text-white">{inspeksiStats.total}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-100 dark:bg-slate-700">
                  <ClipboardCheck className="h-6 w-6 text-slate-600 dark:text-slate-300" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-emerald-50 to-emerald-50/50 dark:from-emerald-900/20 dark:to-emerald-900/10 border-emerald-100 dark:border-emerald-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Aman</p>
                  <p className="text-3xl font-bold text-emerald-600 dark:text-emerald-400">{inspeksiStats.safe}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-emerald-100 dark:bg-emerald-800/50">
                  <CheckCircle2 className="h-6 w-6 text-emerald-600 dark:text-emerald-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-rose-50 to-rose-50/50 dark:from-rose-900/20 dark:to-rose-900/10 border-rose-100 dark:border-rose-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Tidak Aman</p>
                  <p className="text-3xl font-bold text-rose-600 dark:text-rose-400">{inspeksiStats.unsafe}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-rose-100 dark:bg-rose-800/50">
                  <XCircle className="h-6 w-6 text-rose-600 dark:text-rose-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-amber-50 to-amber-50/50 dark:from-amber-900/20 dark:to-amber-900/10 border-amber-100 dark:border-amber-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Pending</p>
                  <p className="text-3xl font-bold text-amber-600 dark:text-amber-400">{inspeksiStats.pending}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-100 dark:bg-amber-800/50">
                  <Clock className="h-6 w-6 text-amber-600 dark:text-amber-400" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Filters */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Inspeksi</CardTitle>
            <CardDescription>
              Lihat semua hasil inspeksi keselamatan kerja
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-4 mb-6">
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Status</SelectItem>
                  <SelectItem value="safe">Aman</SelectItem>
                  <SelectItem value="unsafe">Tidak Aman</SelectItem>
                  <SelectItem value="pending">Pending</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <DataTable
              columns={columns}
              data={filteredData}
              searchKey="title"
              searchPlaceholder="Cari inspeksi..."
              isLoading={isLoading}
            />
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}

