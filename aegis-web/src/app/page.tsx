'use client'

import { DashboardLayout } from '@/components/dashboard-layout'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { IncidentsChart } from '@/components/charts/incidents-chart'
import { InspeksiChart } from '@/components/charts/inspeksi-chart'
import { useDashboardStats, useIncidentChartData, useInspeksiChartData } from '@/hooks/useApi'
import { Skeleton } from '@/components/ui/skeleton'
import {
  ClipboardCheck,
  AlertTriangle,
  FileCheck,
  TrendingUp,
  TrendingDown,
  ArrowRight,
  ShieldCheck,
  AlertCircle,
  Clock,
} from 'lucide-react'
import Link from 'next/link'

// Mock data for demo
const mockStats = {
  totalInspections: 216,
  totalIncidents: 89,
  totalPermits: 145,
  safeInspections: 156,
  unsafeInspections: 42,
  pendingPermits: 23,
  openIncidents: 12,
}

interface StatCardProps {
  title: string
  value: number | string
  description: string
  icon: React.ReactNode
  trend?: {
    value: number
    isPositive: boolean
  }
  variant?: 'default' | 'success' | 'warning' | 'danger'
  href?: string
}

function StatCard({ title, value, description, icon, trend, variant = 'default', href }: StatCardProps) {
  const variantStyles = {
    default: 'from-slate-500/10 to-slate-500/5 border-slate-200 dark:border-slate-700',
    success: 'from-emerald-500/10 to-emerald-500/5 border-emerald-200 dark:border-emerald-800',
    warning: 'from-amber-500/10 to-amber-500/5 border-amber-200 dark:border-amber-800',
    danger: 'from-rose-500/10 to-rose-500/5 border-rose-200 dark:border-rose-800',
  }

  const iconStyles = {
    default: 'from-slate-500 to-slate-600',
    success: 'from-emerald-500 to-teal-500',
    warning: 'from-amber-500 to-orange-500',
    danger: 'from-rose-500 to-red-500',
  }

  return (
    <Card className={`relative overflow-hidden bg-gradient-to-br ${variantStyles[variant]} hover:shadow-lg transition-all duration-300`}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-sm font-medium text-slate-600 dark:text-slate-400">
          {title}
        </CardTitle>
        <div className={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br ${iconStyles[variant]} text-white shadow-lg`}>
          {icon}
        </div>
      </CardHeader>
      <CardContent>
        <div className="flex items-end justify-between">
          <div>
            <div className="text-3xl font-bold text-slate-900 dark:text-white">{value}</div>
            <p className="text-xs text-slate-500 dark:text-slate-400 mt-1">{description}</p>
          </div>
          {trend && (
            <div className={`flex items-center gap-1 text-sm font-medium ${trend.isPositive ? 'text-emerald-500' : 'text-rose-500'}`}>
              {trend.isPositive ? (
                <TrendingUp className="h-4 w-4" />
              ) : (
                <TrendingDown className="h-4 w-4" />
              )}
              {trend.value}%
            </div>
          )}
        </div>
        {href && (
          <Link href={href}>
            <Button variant="ghost" size="sm" className="mt-4 -ml-2 text-slate-500 hover:text-slate-900 dark:hover:text-white">
              Lihat Detail <ArrowRight className="ml-1 h-4 w-4" />
            </Button>
          </Link>
        )}
      </CardContent>
    </Card>
  )
}

function RecentActivityCard() {
  const activities = [
    {
      id: 1,
      type: 'inspection',
      title: 'Inspeksi Area Produksi',
      status: 'safe',
      time: '2 jam lalu',
      user: 'Ahmad Rizki',
    },
    {
      id: 2,
      type: 'incident',
      title: 'Insiden Minor - Lantai Licin',
      status: 'investigating',
      time: '4 jam lalu',
      user: 'Budi Santoso',
    },
    {
      id: 3,
      type: 'permit',
      title: 'PTW Hot Work - Welding',
      status: 'approved',
      time: '5 jam lalu',
      user: 'Siti Rahayu',
    },
    {
      id: 4,
      type: 'inspection',
      title: 'Inspeksi Gudang B',
      status: 'unsafe',
      time: '6 jam lalu',
      user: 'Dian Permata',
    },
    {
      id: 5,
      type: 'permit',
      title: 'PTW Confined Space',
      status: 'pending',
      time: '8 jam lalu',
      user: 'Eko Prasetyo',
    },
  ]

  const getStatusBadge = (status: string) => {
    const variants: Record<string, "success" | "warning" | "danger" | "info" | "default"> = {
      safe: 'success',
      unsafe: 'danger',
      approved: 'success',
      pending: 'warning',
      investigating: 'info',
    }
    const labels: Record<string, string> = {
      safe: 'Aman',
      unsafe: 'Tidak Aman',
      approved: 'Disetujui',
      pending: 'Pending',
      investigating: 'Investigasi',
    }
    return <Badge variant={variants[status] || 'default'}>{labels[status] || status}</Badge>
  }

  const getIcon = (type: string) => {
    switch (type) {
      case 'inspection':
        return <ClipboardCheck className="h-4 w-4" />
      case 'incident':
        return <AlertTriangle className="h-4 w-4" />
      case 'permit':
        return <FileCheck className="h-4 w-4" />
      default:
        return null
    }
  }

  return (
    <Card className="col-span-1">
      <CardHeader className="bg-gradient-to-r from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30 border-b border-slate-100 dark:border-slate-700/50">
        <CardTitle className="flex items-center gap-2">
          <div className="h-2 w-2 rounded-full bg-gradient-to-r from-blue-500 to-purple-500" />
          Aktivitas Terbaru
        </CardTitle>
        <CardDescription>
          Update aktivitas keselamatan kerja
        </CardDescription>
      </CardHeader>
      <CardContent className="pt-4">
        <div className="space-y-4">
          {activities.map((activity, index) => (
            <div
              key={activity.id}
              className="flex items-start gap-3 p-3 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-400">
                {getIcon(activity.type)}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-slate-900 dark:text-white truncate">
                  {activity.title}
                </p>
                <div className="flex items-center gap-2 mt-1">
                  {getStatusBadge(activity.status)}
                  <span className="text-xs text-slate-500">•</span>
                  <span className="text-xs text-slate-500">{activity.time}</span>
                </div>
                <p className="text-xs text-slate-500 mt-1">oleh {activity.user}</p>
              </div>
            </div>
          ))}
        </div>
        <Button variant="outline" className="w-full mt-4">
          Lihat Semua Aktivitas
        </Button>
      </CardContent>
    </Card>
  )
}

export default function DashboardPage() {
  const { data: stats, isLoading: statsLoading } = useDashboardStats()
  const { data: incidentChartData, isLoading: incidentChartLoading } = useIncidentChartData()
  const { data: inspeksiChartData, isLoading: inspeksiChartLoading } = useInspeksiChartData()

  // Use mock data if API fails
  const dashboardStats = stats || mockStats

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold text-slate-900 dark:text-white">
            Dashboard
          </h1>
          <p className="text-slate-500 dark:text-slate-400">
            Selamat datang di Aegis K3 Dashboard. Pantau keselamatan kerja Anda.
          </p>
        </div>

        {/* Quick Stats */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <StatCard
            title="Total Inspeksi"
            value={dashboardStats.totalInspections}
            description="Inspeksi bulan ini"
            icon={<ClipboardCheck className="h-5 w-5" />}
            trend={{ value: 12, isPositive: true }}
            variant="default"
            href="/inspeksi"
          />
          <StatCard
            title="Total Insiden"
            value={dashboardStats.totalIncidents}
            description={`${dashboardStats.openIncidents} masih terbuka`}
            icon={<AlertTriangle className="h-5 w-5" />}
            trend={{ value: 8, isPositive: false }}
            variant="danger"
            href="/incident"
          />
          <StatCard
            title="Permit to Work"
            value={dashboardStats.totalPermits}
            description={`${dashboardStats.pendingPermits} pending approval`}
            icon={<FileCheck className="h-5 w-5" />}
            trend={{ value: 5, isPositive: true }}
            variant="warning"
            href="/permit"
          />
          <StatCard
            title="Tingkat Keselamatan"
            value={`${Math.round((dashboardStats.safeInspections / dashboardStats.totalInspections) * 100)}%`}
            description="Berdasarkan inspeksi"
            icon={<ShieldCheck className="h-5 w-5" />}
            trend={{ value: 3, isPositive: true }}
            variant="success"
          />
        </div>

        {/* Alert Cards */}
        <div className="grid gap-4 md:grid-cols-3">
          <Card className="bg-gradient-to-br from-rose-500/10 to-rose-500/5 border-rose-200 dark:border-rose-800">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-rose-500/20 text-rose-500">
                <AlertCircle className="h-6 w-6" />
              </div>
              <div>
                <p className="text-2xl font-bold text-rose-600 dark:text-rose-400">{dashboardStats.unsafeInspections}</p>
                <p className="text-sm text-slate-600 dark:text-slate-400">Kondisi Tidak Aman</p>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-amber-500/10 to-amber-500/5 border-amber-200 dark:border-amber-800">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-500/20 text-amber-500">
                <Clock className="h-6 w-6" />
              </div>
              <div>
                <p className="text-2xl font-bold text-amber-600 dark:text-amber-400">{dashboardStats.pendingPermits}</p>
                <p className="text-sm text-slate-600 dark:text-slate-400">Permit Menunggu</p>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-blue-500/10 to-blue-500/5 border-blue-200 dark:border-blue-800">
            <CardContent className="flex items-center gap-4 pt-6">
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-blue-500/20 text-blue-500">
                <AlertTriangle className="h-6 w-6" />
              </div>
              <div>
                <p className="text-2xl font-bold text-blue-600 dark:text-blue-400">{dashboardStats.openIncidents}</p>
                <p className="text-sm text-slate-600 dark:text-slate-400">Insiden Aktif</p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Charts */}
        <div className="grid gap-6 lg:grid-cols-3">
          <IncidentsChart data={incidentChartData} isLoading={incidentChartLoading} />
          <InspeksiChart
            data={{
              safe: dashboardStats.safeInspections,
              unsafe: dashboardStats.unsafeInspections,
              pending: 18,
            }}
            isLoading={inspeksiChartLoading}
          />
        </div>

        {/* Recent Activity */}
        <div className="grid gap-6 lg:grid-cols-3">
          <RecentActivityCard />
          <Card className="col-span-2">
            <CardHeader className="bg-gradient-to-r from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30 border-b border-slate-100 dark:border-slate-700/50">
              <CardTitle className="flex items-center gap-2">
                <div className="h-2 w-2 rounded-full bg-gradient-to-r from-teal-500 to-emerald-500" />
                Tips Keselamatan Kerja
              </CardTitle>
            </CardHeader>
            <CardContent className="pt-6">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="flex gap-4 p-4 rounded-xl bg-gradient-to-br from-teal-50 to-emerald-50 dark:from-teal-900/20 dark:to-emerald-900/20 border border-teal-100 dark:border-teal-800">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-teal-500 text-white">
                    <ShieldCheck className="h-5 w-5" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-slate-900 dark:text-white">APD Wajib</h4>
                    <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
                      Pastikan selalu menggunakan Alat Pelindung Diri (APD) sesuai area kerja.
                    </p>
                  </div>
                </div>
                <div className="flex gap-4 p-4 rounded-xl bg-gradient-to-br from-amber-50 to-orange-50 dark:from-amber-900/20 dark:to-orange-900/20 border border-amber-100 dark:border-amber-800">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-amber-500 text-white">
                    <AlertTriangle className="h-5 w-5" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-slate-900 dark:text-white">Laporkan Segera</h4>
                    <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
                      Laporkan setiap kondisi tidak aman atau near miss tanpa menunda.
                    </p>
                  </div>
                </div>
                <div className="flex gap-4 p-4 rounded-xl bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-blue-900/20 dark:to-indigo-900/20 border border-blue-100 dark:border-blue-800">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-500 text-white">
                    <FileCheck className="h-5 w-5" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-slate-900 dark:text-white">Permit to Work</h4>
                    <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
                      Selalu ajukan PTW untuk pekerjaan berisiko tinggi sebelum memulai.
                    </p>
                  </div>
                </div>
                <div className="flex gap-4 p-4 rounded-xl bg-gradient-to-br from-purple-50 to-pink-50 dark:from-purple-900/20 dark:to-pink-900/20 border border-purple-100 dark:border-purple-800">
                  <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-purple-500 text-white">
                    <ClipboardCheck className="h-5 w-5" />
                  </div>
                  <div>
                    <h4 className="font-semibold text-slate-900 dark:text-white">Inspeksi Rutin</h4>
                    <p className="text-sm text-slate-600 dark:text-slate-400 mt-1">
                      Lakukan inspeksi rutin untuk mengidentifikasi potensi bahaya.
                    </p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}

