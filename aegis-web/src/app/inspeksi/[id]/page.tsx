'use client'

import { useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { DashboardLayout } from '@/components/dashboard-layout'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Textarea } from '@/components/ui/textarea'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { useInspeksiDetail, useUpdateInspeksi } from '@/hooks/useApi'
import { InspeksiStatus } from '@/types'
import { formatDateTime, getStatusColor } from '@/lib/utils'
import { toast } from '@/hooks/useToast'
import {
  ArrowLeft,
  ClipboardCheck,
  MapPin,
  User,
  Calendar,
  Building2,
  CheckCircle2,
  XCircle,
  Clock,
  Save,
  Image as ImageIcon,
  AlertTriangle,
  FileText,
} from 'lucide-react'
import Link from 'next/link'
import { Skeleton } from '@/components/ui/skeleton'

// Mock data for demo
const mockInspeksi = {
  id: '1',
  title: 'Inspeksi Area Produksi',
  description: 'Pemeriksaan rutin area produksi untuk memastikan kondisi keselamatan kerja. Inspeksi meliputi pemeriksaan jalur evakuasi, alat pemadam kebakaran, dan kondisi mesin.',
  location: 'Gedung A - Lantai 1',
  status: 'safe' as InspeksiStatus,
  inspector: { id: '1', name: 'Ahmad Rizki' },
  department: 'Produksi',
  area: 'Area Produksi Utama',
  findings: 'Semua kondisi dalam keadaan baik. Jalur evakuasi bebas hambatan, APAR dalam kondisi siap pakai, dan mesin produksi beroperasi normal.',
  recommendations: 'Lanjutkan pemeliharaan rutin dan pastikan checklist harian diisi dengan lengkap.',
  photos: ['/placeholder-inspection-1.jpg', '/placeholder-inspection-2.jpg'],
  createdAt: '2024-01-15T08:00:00Z',
  updatedAt: '2024-01-15T08:30:00Z',
}

export default function InspeksiDetailPage() {
  const params = useParams()
  const router = useRouter()
  const id = params.id as string

  const { data: inspeksi, isLoading } = useInspeksiDetail(id)
  const updateMutation = useUpdateInspeksi()

  // Use mock data if API fails
  const inspeksiData = inspeksi || mockInspeksi

  const [status, setStatus] = useState<InspeksiStatus>(inspeksiData.status)
  const [findings, setFindings] = useState(inspeksiData.findings || '')
  const [recommendations, setRecommendations] = useState(inspeksiData.recommendations || '')
  const [isEditing, setIsEditing] = useState(false)

  const handleSave = async () => {
    try {
      await updateMutation.mutateAsync({
        id,
        data: {
          status,
          findings,
          recommendations,
        },
      })
      toast({
        title: 'Berhasil',
        description: 'Data inspeksi berhasil diperbarui',
        variant: 'success',
      })
      setIsEditing(false)
    } catch (error) {
      toast({
        title: 'Gagal',
        description: 'Terjadi kesalahan saat memperbarui data',
        variant: 'destructive',
      })
    }
  }

  const statusLabels: Record<InspeksiStatus, string> = {
    safe: 'Aman',
    unsafe: 'Tidak Aman',
    pending: 'Pending',
  }

  const statusIcons: Record<InspeksiStatus, React.ReactNode> = {
    safe: <CheckCircle2 className="h-4 w-4" />,
    unsafe: <XCircle className="h-4 w-4" />,
    pending: <Clock className="h-4 w-4" />,
  }

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
            <Link href="/inspeksi">
              <Button variant="ghost" size="icon" className="h-10 w-10">
                <ArrowLeft className="h-5 w-5" />
              </Button>
            </Link>
            <div>
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-teal-500 to-emerald-500 text-white">
                  <ClipboardCheck className="h-5 w-5" />
                </div>
                <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
                  {inspeksiData.title}
                </h1>
                <Badge className={`${getStatusColor(inspeksiData.status)} flex items-center gap-1`}>
                  {statusIcons[inspeksiData.status]}
                  {statusLabels[inspeksiData.status]}
                </Badge>
              </div>
              <p className="text-slate-500 dark:text-slate-400 mt-1 ml-[52px]">
                ID: {inspeksiData.id}
              </p>
            </div>
          </div>
          <div className="flex items-center gap-2 ml-[52px] md:ml-0">
            {isEditing ? (
              <>
                <Button variant="outline" onClick={() => setIsEditing(false)}>
                  Batal
                </Button>
                <Button
                  onClick={handleSave}
                  disabled={updateMutation.isPending}
                  className="bg-gradient-to-r from-teal-500 to-emerald-500 hover:from-teal-600 hover:to-emerald-600 text-white"
                >
                  <Save className="mr-2 h-4 w-4" />
                  {updateMutation.isPending ? 'Menyimpan...' : 'Simpan'}
                </Button>
              </>
            ) : (
              <Button onClick={() => setIsEditing(true)}>
                Edit Inspeksi
              </Button>
            )}
          </div>
        </div>

        <div className="grid gap-6 lg:grid-cols-3">
          {/* Main Content */}
          <div className="space-y-6 lg:col-span-2">
            {/* Description */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <FileText className="h-5 w-5 text-slate-500" />
                  Deskripsi
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed">
                  {inspeksiData.description}
                </p>
              </CardContent>
            </Card>

            {/* Findings */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertTriangle className="h-5 w-5 text-amber-500" />
                  Temuan
                </CardTitle>
                <CardDescription>
                  Hasil temuan dari inspeksi ini
                </CardDescription>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Textarea
                    value={findings}
                    onChange={(e) => setFindings(e.target.value)}
                    placeholder="Masukkan temuan inspeksi..."
                    rows={4}
                  />
                ) : (
                  <p className="text-slate-600 dark:text-slate-400 leading-relaxed">
                    {findings || 'Tidak ada temuan'}
                  </p>
                )}
              </CardContent>
            </Card>

            {/* Recommendations */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CheckCircle2 className="h-5 w-5 text-emerald-500" />
                  Rekomendasi
                </CardTitle>
                <CardDescription>
                  Rekomendasi tindak lanjut
                </CardDescription>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Textarea
                    value={recommendations}
                    onChange={(e) => setRecommendations(e.target.value)}
                    placeholder="Masukkan rekomendasi..."
                    rows={4}
                  />
                ) : (
                  <p className="text-slate-600 dark:text-slate-400 leading-relaxed">
                    {recommendations || 'Tidak ada rekomendasi'}
                  </p>
                )}
              </CardContent>
            </Card>

            {/* Photos */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <ImageIcon className="h-5 w-5 text-blue-500" />
                  Foto Dokumentasi
                </CardTitle>
              </CardHeader>
              <CardContent>
                {inspeksiData.photos && inspeksiData.photos.length > 0 ? (
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                    {inspeksiData.photos.map((photo, index) => (
                      <div
                        key={index}
                        className="aspect-square rounded-xl bg-slate-100 dark:bg-slate-800 flex items-center justify-center border-2 border-dashed border-slate-200 dark:border-slate-700"
                      >
                        <div className="text-center">
                          <ImageIcon className="h-8 w-8 text-slate-400 mx-auto" />
                          <p className="text-xs text-slate-500 mt-2">Foto {index + 1}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="flex flex-col items-center justify-center h-32 text-slate-500">
                    <ImageIcon className="h-8 w-8 mb-2" />
                    <p className="text-sm">Tidak ada foto</p>
                  </div>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Status */}
            <Card>
              <CardHeader>
                <CardTitle>Status Inspeksi</CardTitle>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Select value={status} onValueChange={(value) => setStatus(value as InspeksiStatus)}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="safe">
                        <div className="flex items-center gap-2">
                          <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                          Aman
                        </div>
                      </SelectItem>
                      <SelectItem value="unsafe">
                        <div className="flex items-center gap-2">
                          <XCircle className="h-4 w-4 text-rose-500" />
                          Tidak Aman
                        </div>
                      </SelectItem>
                      <SelectItem value="pending">
                        <div className="flex items-center gap-2">
                          <Clock className="h-4 w-4 text-amber-500" />
                          Pending
                        </div>
                      </SelectItem>
                    </SelectContent>
                  </Select>
                ) : (
                  <Badge className={`${getStatusColor(status)} flex items-center gap-1 w-fit`}>
                    {statusIcons[status]}
                    {statusLabels[status]}
                  </Badge>
                )}
              </CardContent>
            </Card>

            {/* Details */}
            <Card>
              <CardHeader>
                <CardTitle>Detail Inspeksi</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start gap-3">
                  <MapPin className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Lokasi</p>
                    <p className="text-sm text-slate-500">{inspeksiData.location}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Building2 className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Departemen</p>
                    <p className="text-sm text-slate-500">{inspeksiData.department || '-'}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <User className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Inspektor</p>
                    <p className="text-sm text-slate-500">{inspeksiData.inspector.name}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Calendar className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Tanggal Inspeksi</p>
                    <p className="text-sm text-slate-500">{formatDateTime(inspeksiData.createdAt)}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Clock className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Terakhir Diperbarui</p>
                    <p className="text-sm text-slate-500">{formatDateTime(inspeksiData.updatedAt)}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

