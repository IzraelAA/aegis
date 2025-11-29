'use client'

import { useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { DashboardLayout } from '@/components/dashboard-layout'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Textarea } from '@/components/ui/textarea'
import { usePermitDetail, useApprovePermit } from '@/hooks/useApi'
import { PermitType, PermitStatus } from '@/types'
import { formatDate, formatDateTime, getStatusColor } from '@/lib/utils'
import { toast } from '@/hooks/useToast'
import { useAuth } from '@/hooks/useAuth'
import { canApprovePermits } from '@/lib/auth'
import {
  ArrowLeft,
  FileCheck,
  MapPin,
  User,
  Calendar,
  Building2,
  CheckCircle2,
  XCircle,
  Clock,
  Flame,
  Box,
  ArrowUp,
  Zap,
  Shovel,
  FileText,
  AlertTriangle,
  Shield,
  Users,
  Package,
} from 'lucide-react'
import Link from 'next/link'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'

// Mock data for demo
const mockPermit = {
  id: '1',
  permitNumber: 'PTW-2024-001',
  type: 'hot_work' as PermitType,
  title: 'Pekerjaan Pengelasan Pipa',
  description: 'Pengelasan sambungan pipa di area produksi untuk perbaikan sistem perpipaan. Pekerjaan meliputi pemotongan pipa lama dan pengelasan pipa baru.',
  location: 'Area Produksi - Blok A',
  status: 'pending' as PermitStatus,
  startDate: '2024-01-20',
  endDate: '2024-01-22',
  requester: { id: '1', name: 'Ahmad Rizki' },
  approver: undefined,
  department: 'Produksi',
  hazards: ['Kebakaran', 'Luka bakar', 'Percikan api', 'Asap las'],
  precautions: [
    'Area kerja bebas dari bahan mudah terbakar',
    'APAR tersedia di lokasi',
    'Pengawas kebakaran standby',
    'APD las lengkap',
  ],
  equipment: ['Mesin las', 'Tabung gas', 'Helm las', 'Sarung tangan las', 'Apron'],
  workers: [
    { id: '1', name: 'Ahmad Rizki' },
    { id: '2', name: 'Budi Santoso' },
  ],
  rejectionReason: undefined,
  createdAt: '2024-01-15T08:00:00Z',
  updatedAt: '2024-01-15T08:00:00Z',
}

const permitTypeLabels: Record<PermitType, string> = {
  hot_work: 'Hot Work',
  confined_space: 'Confined Space',
  height_work: 'Kerja Ketinggian',
  electrical: 'Listrik',
  excavation: 'Penggalian',
  general: 'Umum',
}

const permitTypeIcons: Record<PermitType, React.ReactNode> = {
  hot_work: <Flame className="h-5 w-5" />,
  confined_space: <Box className="h-5 w-5" />,
  height_work: <ArrowUp className="h-5 w-5" />,
  electrical: <Zap className="h-5 w-5" />,
  excavation: <Shovel className="h-5 w-5" />,
  general: <FileText className="h-5 w-5" />,
}

const permitTypeColors: Record<PermitType, string> = {
  hot_work: 'from-orange-500 to-red-500',
  confined_space: 'from-purple-500 to-indigo-500',
  height_work: 'from-blue-500 to-cyan-500',
  electrical: 'from-yellow-500 to-amber-500',
  excavation: 'from-emerald-500 to-green-500',
  general: 'from-slate-500 to-gray-500',
}

export default function PermitDetailPage() {
  const params = useParams()
  const router = useRouter()
  const id = params.id as string
  const { user } = useAuth()

  const { data: permit, isLoading } = usePermitDetail(id)
  const approveMutation = useApprovePermit()

  // Use mock data if API fails
  const permitData = permit || mockPermit

  const [rejectionReason, setRejectionReason] = useState('')
  const [showRejectDialog, setShowRejectDialog] = useState(false)

  const handleApprove = async () => {
    try {
      await approveMutation.mutateAsync({
        id,
        data: { approved: true },
      })
      toast({
        title: 'Berhasil',
        description: 'Permit telah disetujui',
        variant: 'success',
      })
    } catch (error) {
      toast({
        title: 'Gagal',
        description: 'Terjadi kesalahan saat menyetujui permit',
        variant: 'destructive',
      })
    }
  }

  const handleReject = async () => {
    if (!rejectionReason.trim()) {
      toast({
        title: 'Error',
        description: 'Alasan penolakan harus diisi',
        variant: 'destructive',
      })
      return
    }

    try {
      await approveMutation.mutateAsync({
        id,
        data: { approved: false, rejectionReason },
      })
      toast({
        title: 'Berhasil',
        description: 'Permit telah ditolak',
        variant: 'success',
      })
      setShowRejectDialog(false)
    } catch (error) {
      toast({
        title: 'Gagal',
        description: 'Terjadi kesalahan saat menolak permit',
        variant: 'destructive',
      })
    }
  }

  const statusLabels: Record<PermitStatus, string> = {
    pending: 'Pending',
    approved: 'Disetujui',
    rejected: 'Ditolak',
    expired: 'Expired',
    closed: 'Closed',
  }

  const statusIcons: Record<PermitStatus, React.ReactNode> = {
    pending: <Clock className="h-4 w-4" />,
    approved: <CheckCircle2 className="h-4 w-4" />,
    rejected: <XCircle className="h-4 w-4" />,
    expired: <Clock className="h-4 w-4" />,
    closed: <CheckCircle2 className="h-4 w-4" />,
  }

  const canApprove = canApprovePermits(user) && permitData.status === 'pending'

  if (isLoading) {
    return (
      <DashboardLayout>
        <div className="space-y-6">
          <div className="flex items-center gap-4">
            <Skeleton className="h-10 w-10 rounded-xl" />
            <div className="space-y-2">
              <Skeleton className="h-8 w-64" />
              <Skeleton className="h-4 w-48" />
            </div>
          </div>
          <div className="grid gap-6 lg:grid-cols-3">
            <Skeleton className="h-[400px] col-span-2" />
            <Skeleton className="h-[400px]" />
          </div>
        </div>
      </DashboardLayout>
    )
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
          <div className="flex items-start gap-4">
            <Link href="/permit">
              <Button variant="ghost" size="icon" className="h-10 w-10">
                <ArrowLeft className="h-5 w-5" />
              </Button>
            </Link>
            <div>
              <div className="flex items-center gap-3 flex-wrap">
                <div className={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br ${permitTypeColors[permitData.type]} text-white`}>
                  {permitTypeIcons[permitData.type]}
                </div>
                <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
                  {permitData.title}
                </h1>
                <Badge className={`${getStatusColor(permitData.status)} flex items-center gap-1`}>
                  {statusIcons[permitData.status]}
                  {statusLabels[permitData.status]}
                </Badge>
              </div>
              <div className="flex items-center gap-2 mt-1 ml-[52px]">
                <span className="font-mono text-sm text-slate-500">{permitData.permitNumber}</span>
                <span className="text-slate-300">•</span>
                <span className="text-sm text-slate-500">{permitTypeLabels[permitData.type]}</span>
              </div>
            </div>
          </div>
          {canApprove && (
            <div className="flex items-center gap-2 ml-[52px] md:ml-0">
              <Dialog open={showRejectDialog} onOpenChange={setShowRejectDialog}>
                <DialogTrigger asChild>
                  <Button variant="outline" className="text-rose-600 border-rose-200 hover:bg-rose-50">
                    <XCircle className="mr-2 h-4 w-4" />
                    Tolak
                  </Button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Tolak Permit</DialogTitle>
                    <DialogDescription>
                      Berikan alasan penolakan untuk permit ini.
                    </DialogDescription>
                  </DialogHeader>
                  <Textarea
                    value={rejectionReason}
                    onChange={(e) => setRejectionReason(e.target.value)}
                    placeholder="Alasan penolakan..."
                    rows={4}
                  />
                  <DialogFooter>
                    <Button variant="outline" onClick={() => setShowRejectDialog(false)}>
                      Batal
                    </Button>
                    <Button
                      onClick={handleReject}
                      disabled={approveMutation.isPending}
                      className="bg-rose-500 hover:bg-rose-600 text-white"
                    >
                      {approveMutation.isPending ? 'Memproses...' : 'Konfirmasi Tolak'}
                    </Button>
                  </DialogFooter>
                </DialogContent>
              </Dialog>
              <Button
                onClick={handleApprove}
                disabled={approveMutation.isPending}
                className="bg-gradient-to-r from-emerald-500 to-green-500 hover:from-emerald-600 hover:to-green-600 text-white"
              >
                <CheckCircle2 className="mr-2 h-4 w-4" />
                {approveMutation.isPending ? 'Memproses...' : 'Setujui'}
              </Button>
            </div>
          )}
        </div>

        <div className="grid gap-6 lg:grid-cols-3">
          {/* Main Content */}
          <div className="space-y-6 lg:col-span-2">
            {/* Description */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5 text-slate-500" />
                  Deskripsi Pekerjaan
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed">
                  {permitData.description}
                </p>
              </CardContent>
            </Card>

            {/* Hazards */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="h-5 w-5 text-amber-500" />
                  Potensi Bahaya
                </CardTitle>
                <CardDescription>
                  Bahaya yang teridentifikasi dari pekerjaan ini
                </CardDescription>
              </CardHeader>
              <CardContent>
                {permitData.hazards && permitData.hazards.length > 0 ? (
                  <div className="flex flex-wrap gap-2">
                    {permitData.hazards.map((hazard, index) => (
                      <Badge
                        key={index}
                        variant="outline"
                        className="bg-amber-50 text-amber-700 border-amber-200"
                      >
                        {hazard}
                      </Badge>
                    ))}
                  </div>
                ) : (
                  <p className="text-slate-500">Tidak ada bahaya teridentifikasi</p>
                )}
              </CardContent>
            </Card>

            {/* Precautions */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="h-5 w-5 text-emerald-500" />
                  Langkah Pencegahan
                </CardTitle>
                <CardDescription>
                  Tindakan pencegahan yang harus dilakukan
                </CardDescription>
              </CardHeader>
              <CardContent>
                {permitData.precautions && permitData.precautions.length > 0 ? (
                  <ul className="space-y-2">
                    {permitData.precautions.map((precaution, index) => (
                      <li
                        key={index}
                        className="flex items-start gap-2 text-slate-600 dark:text-slate-400"
                      >
                        <CheckCircle2 className="h-4 w-4 text-emerald-500 mt-0.5 shrink-0" />
                        <span>{precaution}</span>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p className="text-slate-500">Tidak ada langkah pencegahan</p>
                )}
              </CardContent>
            </Card>

            {/* Equipment */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Package className="h-5 w-5 text-blue-500" />
                  Peralatan & APD
                </CardTitle>
                <CardDescription>
                  Peralatan dan APD yang diperlukan
                </CardDescription>
              </CardHeader>
              <CardContent>
                {permitData.equipment && permitData.equipment.length > 0 ? (
                  <div className="flex flex-wrap gap-2">
                    {permitData.equipment.map((item, index) => (
                      <Badge
                        key={index}
                        variant="outline"
                        className="bg-blue-50 text-blue-700 border-blue-200"
                      >
                        {item}
                      </Badge>
                    ))}
                  </div>
                ) : (
                  <p className="text-slate-500">Tidak ada peralatan khusus</p>
                )}
              </CardContent>
            </Card>

            {/* Rejection Reason (if rejected) */}
            {permitData.status === 'rejected' && permitData.rejectionReason && (
              <Card className="border-rose-200 bg-rose-50/50">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-rose-700">
                    <XCircle className="h-5 w-5" />
                    Alasan Penolakan
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-rose-600">{permitData.rejectionReason}</p>
                </CardContent>
              </Card>
            )}
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Period */}
            <Card>
              <CardHeader>
                <CardTitle>Periode Kerja</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start gap-3">
                  <Calendar className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Mulai</p>
                    <p className="text-sm text-slate-500">{formatDate(permitData.startDate)}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Calendar className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Selesai</p>
                    <p className="text-sm text-slate-500">{formatDate(permitData.endDate)}</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Details */}
            <Card>
              <CardHeader>
                <CardTitle>Detail Permit</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start gap-3">
                  <MapPin className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Lokasi</p>
                    <p className="text-sm text-slate-500">{permitData.location}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Building2 className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Departemen</p>
                    <p className="text-sm text-slate-500">{permitData.department || '-'}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <User className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Pemohon</p>
                    <p className="text-sm text-slate-500">{permitData.requester.name}</p>
                  </div>
                </div>
                {permitData.approver && (
                  <div className="flex items-start gap-3">
                    <CheckCircle2 className="h-5 w-5 text-slate-400 mt-0.5" />
                    <div>
                      <p className="text-sm font-medium text-slate-900 dark:text-white">Disetujui Oleh</p>
                      <p className="text-sm text-slate-500">{permitData.approver.name}</p>
                    </div>
                  </div>
                )}
                <div className="flex items-start gap-3">
                  <Clock className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Diajukan</p>
                    <p className="text-sm text-slate-500">{formatDateTime(permitData.createdAt)}</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Workers */}
            {permitData.workers && permitData.workers.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="h-5 w-5 text-slate-400" />
                    Pekerja
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {permitData.workers.map((worker, index) => (
                      <li key={index} className="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-400">
                        <div className="h-2 w-2 rounded-full bg-slate-300" />
                        {worker.name}
                      </li>
                    ))}
                  </ul>
                </CardContent>
              </Card>
            )}
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

