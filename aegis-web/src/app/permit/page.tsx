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
import { usePermitList, usePermitStats } from '@/hooks/useApi'
import { Permit, PermitType, PermitStatus } from '@/types'
import { ColumnDef } from '@tanstack/react-table'
import { formatDate, getStatusColor } from '@/lib/utils'
import {
  FileCheck,
  Plus,
  Eye,
  MoreHorizontal,
  MapPin,
  User,
  Clock,
  CheckCircle2,
  XCircle,
  Flame,
  Box,
  ArrowUp,
  Zap,
  Shovel,
  FileText,
  Calendar,
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
const mockPermits: Permit[] = [
  {
    id: '1',
    permitNumber: 'PTW-2024-001',
    type: 'hot_work',
    title: 'Pekerjaan Pengelasan Pipa',
    description: 'Pengelasan sambungan pipa di area produksi',
    location: 'Area Produksi - Blok A',
    status: 'approved',
    startDate: '2024-01-20',
    endDate: '2024-01-22',
    requester: { id: '1', name: 'Ahmad Rizki' },
    approver: { id: '2', name: 'Budi Santoso' },
    department: 'Produksi',
    createdAt: '2024-01-15T08:00:00Z',
    updatedAt: '2024-01-16T10:00:00Z',
  },
  {
    id: '2',
    permitNumber: 'PTW-2024-002',
    type: 'confined_space',
    title: 'Pembersihan Tangki Air',
    description: 'Pembersihan dan inspeksi tangki air bawah tanah',
    location: 'Tangki Air - Basement',
    status: 'pending',
    startDate: '2024-01-25',
    endDate: '2024-01-25',
    requester: { id: '3', name: 'Siti Rahayu' },
    department: 'Maintenance',
    createdAt: '2024-01-16T09:00:00Z',
    updatedAt: '2024-01-16T09:00:00Z',
  },
  {
    id: '3',
    permitNumber: 'PTW-2024-003',
    type: 'height_work',
    title: 'Perawatan AC Outdoor',
    description: 'Service dan perawatan unit AC outdoor di lantai 5',
    location: 'Gedung Utama - Lantai 5',
    status: 'approved',
    startDate: '2024-01-18',
    endDate: '2024-01-18',
    requester: { id: '4', name: 'Dian Permata' },
    approver: { id: '5', name: 'Eko Prasetyo' },
    department: 'Facility',
    createdAt: '2024-01-14T11:00:00Z',
    updatedAt: '2024-01-15T08:00:00Z',
  },
  {
    id: '4',
    permitNumber: 'PTW-2024-004',
    type: 'electrical',
    title: 'Perbaikan Panel Listrik',
    description: 'Perbaikan dan upgrade panel distribusi listrik',
    location: 'Ruang Panel - Gedung B',
    status: 'rejected',
    startDate: '2024-01-22',
    endDate: '2024-01-23',
    requester: { id: '6', name: 'Fajar Nugroho' },
    department: 'Electrical',
    rejectionReason: 'Dokumen JSA belum lengkap',
    createdAt: '2024-01-13T14:00:00Z',
    updatedAt: '2024-01-14T09:00:00Z',
  },
  {
    id: '5',
    permitNumber: 'PTW-2024-005',
    type: 'excavation',
    title: 'Penggalian Jalur Kabel',
    description: 'Penggalian untuk pemasangan jalur kabel baru',
    location: 'Area Parkir',
    status: 'pending',
    startDate: '2024-01-28',
    endDate: '2024-01-30',
    requester: { id: '7', name: 'Gita Puspita' },
    department: 'Civil',
    createdAt: '2024-01-17T10:00:00Z',
    updatedAt: '2024-01-17T10:00:00Z',
  },
]

const permitTypeLabels: Record<PermitType, string> = {
  hot_work: 'Hot Work',
  confined_space: 'Confined Space',
  height_work: 'Kerja Ketinggian',
  electrical: 'Listrik',
  excavation: 'Penggalian',
  general: 'Umum',
}

const permitTypeIcons: Record<PermitType, React.ReactNode> = {
  hot_work: <Flame className="h-4 w-4" />,
  confined_space: <Box className="h-4 w-4" />,
  height_work: <ArrowUp className="h-4 w-4" />,
  electrical: <Zap className="h-4 w-4" />,
  excavation: <Shovel className="h-4 w-4" />,
  general: <FileText className="h-4 w-4" />,
}

const columns: ColumnDef<Permit>[] = [
  {
    accessorKey: 'permitNumber',
    header: 'No. Permit',
    cell: ({ row }) => (
      <span className="font-mono text-sm font-medium text-slate-900 dark:text-white">
        {row.original.permitNumber}
      </span>
    ),
  },
  {
    accessorKey: 'title',
    header: 'Judul',
    cell: ({ row }) => (
      <div className="flex flex-col">
        <span className="font-medium text-slate-900 dark:text-white">
          {row.original.title}
        </span>
        <div className="flex items-center gap-1.5 text-xs text-slate-500 mt-0.5">
          {permitTypeIcons[row.original.type]}
          <span>{permitTypeLabels[row.original.type]}</span>
        </div>
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
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => {
      const status = row.original.status
      const statusLabels: Record<PermitStatus, string> = {
        pending: 'Pending',
        approved: 'Disetujui',
        rejected: 'Ditolak',
        expired: 'Expired',
        closed: 'Closed',
      }
      const statusIcons: Record<PermitStatus, React.ReactNode> = {
        pending: <Clock className="h-3.5 w-3.5" />,
        approved: <CheckCircle2 className="h-3.5 w-3.5" />,
        rejected: <XCircle className="h-3.5 w-3.5" />,
        expired: <Clock className="h-3.5 w-3.5" />,
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
    accessorKey: 'startDate',
    header: 'Periode',
    cell: ({ row }) => (
      <div className="flex items-center gap-1.5 text-sm text-slate-600 dark:text-slate-400">
        <Calendar className="h-4 w-4" />
        <span>{formatDate(row.original.startDate)}</span>
      </div>
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
            <Link href={`/permit/${row.original.id}`}>
              <Eye className="mr-2 h-4 w-4" />
              Lihat Detail
            </Link>
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
]

export default function PermitPage() {
  const [typeFilter, setTypeFilter] = useState<string>('all')
  const [statusFilter, setStatusFilter] = useState<string>('all')
  const router = useRouter()

  const { data, isLoading } = usePermitList({
    ...(typeFilter !== 'all' && { type: typeFilter }),
    ...(statusFilter !== 'all' && { status: statusFilter }),
  })
  const { data: stats } = usePermitStats()

  // Use mock data if API fails
  const permitData = data?.data || mockPermits
  let filteredData = permitData

  if (typeFilter !== 'all') {
    filteredData = filteredData.filter(p => p.type === typeFilter)
  }
  if (statusFilter !== 'all') {
    filteredData = filteredData.filter(p => p.status === statusFilter)
  }

  const mockStats = {
    total: 145,
    pending: 23,
    approved: 98,
    rejected: 12,
    expired: 12,
  }

  const permitStats = stats || mockStats

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <h1 className="text-3xl font-bold text-slate-900 dark:text-white flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-amber-500 to-orange-500 text-white">
                <FileCheck className="h-5 w-5" />
              </div>
              Permit to Work
            </h1>
            <p className="text-slate-500 dark:text-slate-400 mt-1">
              Kelola izin kerja untuk pekerjaan berisiko tinggi
            </p>
          </div>
          <Button className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white shadow-lg shadow-amber-500/25">
            <Plus className="mr-2 h-4 w-4" />
            Ajukan Permit
          </Button>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-5">
          <Card className="bg-gradient-to-br from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Total PTW</p>
                  <p className="text-3xl font-bold text-slate-900 dark:text-white">{permitStats.total}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-100 dark:bg-slate-700">
                  <FileCheck className="h-6 w-6 text-slate-600 dark:text-slate-300" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-amber-50 to-amber-50/50 dark:from-amber-900/20 dark:to-amber-900/10 border-amber-100 dark:border-amber-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Pending</p>
                  <p className="text-3xl font-bold text-amber-600 dark:text-amber-400">{permitStats.pending}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-100 dark:bg-amber-800/50">
                  <Clock className="h-6 w-6 text-amber-600 dark:text-amber-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-emerald-50 to-emerald-50/50 dark:from-emerald-900/20 dark:to-emerald-900/10 border-emerald-100 dark:border-emerald-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Disetujui</p>
                  <p className="text-3xl font-bold text-emerald-600 dark:text-emerald-400">{permitStats.approved}</p>
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
                  <p className="text-sm font-medium text-slate-500">Ditolak</p>
                  <p className="text-3xl font-bold text-rose-600 dark:text-rose-400">{permitStats.rejected}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-rose-100 dark:bg-rose-800/50">
                  <XCircle className="h-6 w-6 text-rose-600 dark:text-rose-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-slate-50 to-slate-50/50 dark:from-slate-900/20 dark:to-slate-900/10 border-slate-200 dark:border-slate-700">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Expired</p>
                  <p className="text-3xl font-bold text-slate-600 dark:text-slate-400">{permitStats.expired}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-100 dark:bg-slate-800">
                  <Clock className="h-6 w-6 text-slate-600 dark:text-slate-400" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Table */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Permit to Work</CardTitle>
            <CardDescription>
              Lihat semua permit to work yang telah diajukan
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap items-center gap-4 mb-6">
              <Select value={typeFilter} onValueChange={setTypeFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Tipe" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Tipe</SelectItem>
                  <SelectItem value="hot_work">Hot Work</SelectItem>
                  <SelectItem value="confined_space">Confined Space</SelectItem>
                  <SelectItem value="height_work">Kerja Ketinggian</SelectItem>
                  <SelectItem value="electrical">Listrik</SelectItem>
                  <SelectItem value="excavation">Penggalian</SelectItem>
                  <SelectItem value="general">Umum</SelectItem>
                </SelectContent>
              </Select>
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Status</SelectItem>
                  <SelectItem value="pending">Pending</SelectItem>
                  <SelectItem value="approved">Disetujui</SelectItem>
                  <SelectItem value="rejected">Ditolak</SelectItem>
                  <SelectItem value="expired">Expired</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <DataTable
              columns={columns}
              data={filteredData}
              searchKey="title"
              searchPlaceholder="Cari permit..."
              isLoading={isLoading}
            />
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}

