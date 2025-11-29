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
import { useIncidentDetail, useUpdateIncident } from '@/hooks/useApi'
import { IncidentSeverity, IncidentStatus } from '@/types'
import { formatDateTime, getStatusColor } from '@/lib/utils'
import { toast } from '@/hooks/useToast'
import {
  ArrowLeft,
  AlertTriangle,
  MapPin,
  User,
  Calendar,
  Building2,
  Save,
  Image as ImageIcon,
  FileText,
  AlertCircle,
  AlertOctagon,
  CircleDot,
  Search,
  CheckCircle2,
  Clock,
  Users,
  Target,
  Shield,
} from 'lucide-react'
import Link from 'next/link'
import { Skeleton } from '@/components/ui/skeleton'

// Mock data for demo
const mockIncident = {
  id: '1',
  title: 'Tumpahan Bahan Kimia',
  description: 'Terjadi tumpahan bahan kimia di area laboratorium saat proses transfer cairan dari wadah besar ke wadah kecil. Tumpahan terjadi akibat wadah yang tidak stabil.',
  location: 'Laboratorium Kimia - Ruang Uji A',
  severity: 'major' as IncidentSeverity,
  status: 'investigating' as IncidentStatus,
  date: '2024-01-15',
  time: '08:30',
  reporter: { id: '1', name: 'Ahmad Rizki' },
  investigator: { id: '2', name: 'Dr. Siti Aminah' },
  department: 'R&D',
  witnesses: ['Budi Santoso', 'Dian Permata'],
  injuredPersons: 0,
  rootCause: 'Wadah transfer tidak memiliki penyangga yang cukup stabil dan tidak ada secondary containment.',
  correctiveActions: '1. Segera membersihkan area tumpahan dengan prosedur HAZMAT\n2. Melaporkan ke tim K3\n3. Memastikan ventilasi area berjalan baik',
  preventiveMeasures: '1. Menyediakan secondary containment untuk semua proses transfer\n2. Memasang stabilizer pada wadah transfer\n3. Melakukan refresher training prosedur transfer bahan kimia',
  photos: ['/placeholder-incident-1.jpg', '/placeholder-incident-2.jpg'],
  createdAt: '2024-01-15T08:00:00Z',
  updatedAt: '2024-01-15T09:00:00Z',
}

export default function IncidentDetailPage() {
  const params = useParams()
  const router = useRouter()
  const id = params.id as string

  const { data: incident, isLoading } = useIncidentDetail(id)
  const updateMutation = useUpdateIncident()

  // Use mock data if API fails
  const incidentData = incident || mockIncident

  const [status, setStatus] = useState<IncidentStatus>(incidentData.status)
  const [rootCause, setRootCause] = useState(incidentData.rootCause || '')
  const [correctiveActions, setCorrectiveActions] = useState(incidentData.correctiveActions || '')
  const [preventiveMeasures, setPreventiveMeasures] = useState(incidentData.preventiveMeasures || '')
  const [isEditing, setIsEditing] = useState(false)

  const handleSave = async () => {
    try {
      await updateMutation.mutateAsync({
        id,
        data: {
          status,
          rootCause,
          correctiveActions,
          preventiveMeasures,
        },
      })
      toast({
        title: 'Berhasil',
        description: 'Data insiden berhasil diperbarui',
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

  const severityLabels: Record<IncidentSeverity, string> = {
    minor: 'Minor',
    major: 'Major',
    'near-miss': 'Near Miss',
  }

  const severityIcons: Record<IncidentSeverity, React.ReactNode> = {
    minor: <AlertCircle className="h-4 w-4" />,
    major: <AlertOctagon className="h-4 w-4" />,
    'near-miss': <CircleDot className="h-4 w-4" />,
  }

  const statusLabels: Record<IncidentStatus, string> = {
    open: 'Open',
    investigating: 'Investigasi',
    closed: 'Closed',
  }

  const statusIcons: Record<IncidentStatus, React.ReactNode> = {
    open: <Clock className="h-4 w-4" />,
    investigating: <Search className="h-4 w-4" />,
    closed: <CheckCircle2 className="h-4 w-4" />,
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
            <Link href="/incident">
              <Button variant="ghost" size="icon" className="h-10 w-10">
                <ArrowLeft className="h-5 w-5" />
              </Button>
            </Link>
            <div>
              <div className="flex items-center gap-3 flex-wrap">
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-rose-500 to-red-500 text-white">
                  <AlertTriangle className="h-5 w-5" />
                </div>
                <h1 className="text-2xl font-bold text-slate-900 dark:text-white">
                  {incidentData.title}
                </h1>
                <Badge className={`${getStatusColor(incidentData.severity)} flex items-center gap-1`}>
                  {severityIcons[incidentData.severity]}
                  {severityLabels[incidentData.severity]}
                </Badge>
                <Badge className={`${getStatusColor(incidentData.status)} flex items-center gap-1`}>
                  {statusIcons[incidentData.status]}
                  {statusLabels[incidentData.status]}
                </Badge>
              </div>
              <p className="text-slate-500 dark:text-slate-400 mt-1 ml-[52px]">
                ID: {incidentData.id}
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
                  className="bg-gradient-to-r from-rose-500 to-red-500 hover:from-rose-600 hover:to-red-600 text-white"
                >
                  <Save className="mr-2 h-4 w-4" />
                  {updateMutation.isPending ? 'Menyimpan...' : 'Simpan'}
                </Button>
              </>
            ) : (
              <Button onClick={() => setIsEditing(true)}>
                Update Investigasi
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
                  Deskripsi Insiden
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-slate-600 dark:text-slate-400 leading-relaxed">
                  {incidentData.description}
                </p>
              </CardContent>
            </Card>

            {/* Root Cause */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Target className="h-5 w-5 text-rose-500" />
                  Akar Penyebab
                </CardTitle>
                <CardDescription>
                  Analisis penyebab utama insiden
                </CardDescription>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Textarea
                    value={rootCause}
                    onChange={(e) => setRootCause(e.target.value)}
                    placeholder="Masukkan akar penyebab insiden..."
                    rows={4}
                  />
                ) : (
                  <p className="text-slate-600 dark:text-slate-400 leading-relaxed whitespace-pre-line">
                    {rootCause || 'Belum dianalisis'}
                  </p>
                )}
              </CardContent>
            </Card>

            {/* Corrective Actions */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <AlertCircle className="h-5 w-5 text-amber-500" />
                  Tindakan Korektif
                </CardTitle>
                <CardDescription>
                  Langkah-langkah yang telah diambil untuk mengatasi insiden
                </CardDescription>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Textarea
                    value={correctiveActions}
                    onChange={(e) => setCorrectiveActions(e.target.value)}
                    placeholder="Masukkan tindakan korektif..."
                    rows={4}
                  />
                ) : (
                  <p className="text-slate-600 dark:text-slate-400 leading-relaxed whitespace-pre-line">
                    {correctiveActions || 'Belum ada tindakan'}
                  </p>
                )}
              </CardContent>
            </Card>

            {/* Preventive Measures */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Shield className="h-5 w-5 text-emerald-500" />
                  Langkah Pencegahan
                </CardTitle>
                <CardDescription>
                  Upaya mencegah insiden serupa terulang
                </CardDescription>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Textarea
                    value={preventiveMeasures}
                    onChange={(e) => setPreventiveMeasures(e.target.value)}
                    placeholder="Masukkan langkah pencegahan..."
                    rows={4}
                  />
                ) : (
                  <p className="text-slate-600 dark:text-slate-400 leading-relaxed whitespace-pre-line">
                    {preventiveMeasures || 'Belum ditentukan'}
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
                {incidentData.photos && incidentData.photos.length > 0 ? (
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                    {incidentData.photos.map((photo, index) => (
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
                <CardTitle>Status Investigasi</CardTitle>
              </CardHeader>
              <CardContent>
                {isEditing ? (
                  <Select value={status} onValueChange={(value) => setStatus(value as IncidentStatus)}>
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="open">
                        <div className="flex items-center gap-2">
                          <Clock className="h-4 w-4 text-amber-500" />
                          Open
                        </div>
                      </SelectItem>
                      <SelectItem value="investigating">
                        <div className="flex items-center gap-2">
                          <Search className="h-4 w-4 text-purple-500" />
                          Investigasi
                        </div>
                      </SelectItem>
                      <SelectItem value="closed">
                        <div className="flex items-center gap-2">
                          <CheckCircle2 className="h-4 w-4 text-emerald-500" />
                          Closed
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
                <CardTitle>Detail Insiden</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start gap-3">
                  <MapPin className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Lokasi</p>
                    <p className="text-sm text-slate-500">{incidentData.location}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <Building2 className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Departemen</p>
                    <p className="text-sm text-slate-500">{incidentData.department || '-'}</p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <User className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Pelapor</p>
                    <p className="text-sm text-slate-500">{incidentData.reporter.name}</p>
                  </div>
                </div>
                {incidentData.investigator && (
                  <div className="flex items-start gap-3">
                    <Search className="h-5 w-5 text-slate-400 mt-0.5" />
                    <div>
                      <p className="text-sm font-medium text-slate-900 dark:text-white">Investigator</p>
                      <p className="text-sm text-slate-500">{incidentData.investigator.name}</p>
                    </div>
                  </div>
                )}
                <div className="flex items-start gap-3">
                  <Calendar className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Tanggal & Waktu</p>
                    <p className="text-sm text-slate-500">
                      {incidentData.date} {incidentData.time && `- ${incidentData.time}`}
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-3">
                  <AlertTriangle className="h-5 w-5 text-slate-400 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-slate-900 dark:text-white">Korban Luka</p>
                    <p className="text-sm text-slate-500">{incidentData.injuredPersons || 0} orang</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Witnesses */}
            {incidentData.witnesses && incidentData.witnesses.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Users className="h-5 w-5 text-slate-400" />
                    Saksi
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {incidentData.witnesses.map((witness, index) => (
                      <li key={index} className="flex items-center gap-2 text-sm text-slate-600 dark:text-slate-400">
                        <div className="h-2 w-2 rounded-full bg-slate-300" />
                        {witness}
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

