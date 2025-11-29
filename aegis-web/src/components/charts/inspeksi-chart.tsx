'use client'

import {
  PieChart,
  Pie,
  Cell,
  ResponsiveContainer,
  Legend,
  Tooltip,
} from 'recharts'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { InspeksiChartData } from '@/types'
import { Skeleton } from '@/components/ui/skeleton'

interface InspeksiChartProps {
  data?: { safe: number; unsafe: number; pending?: number }
  isLoading?: boolean
}

const COLORS = {
  safe: '#10b981',
  unsafe: '#ef4444',
  pending: '#f59e0b',
}

const CustomTooltip = ({ active, payload }: any) => {
  if (active && payload && payload.length) {
    const data = payload[0]
    return (
      <div className="bg-white dark:bg-slate-800 p-3 rounded-lg shadow-lg border border-slate-200 dark:border-slate-700">
        <div className="flex items-center gap-2">
          <div
            className="w-3 h-3 rounded-full"
            style={{ backgroundColor: data.payload.fill }}
          />
          <span className="font-medium text-slate-900 dark:text-white">
            {data.name}: {data.value}
          </span>
        </div>
        <p className="text-xs text-slate-500 mt-1">
          {((data.value / data.payload.total) * 100).toFixed(1)}% dari total
        </p>
      </div>
    )
  }
  return null
}

const renderCustomLabel = ({
  cx,
  cy,
  midAngle,
  innerRadius,
  outerRadius,
  percent,
}: any) => {
  const RADIAN = Math.PI / 180
  const radius = innerRadius + (outerRadius - innerRadius) * 0.5
  const x = cx + radius * Math.cos(-midAngle * RADIAN)
  const y = cy + radius * Math.sin(-midAngle * RADIAN)

  if (percent < 0.05) return null

  return (
    <text
      x={x}
      y={y}
      fill="white"
      textAnchor="middle"
      dominantBaseline="central"
      className="text-sm font-semibold"
    >
      {`${(percent * 100).toFixed(0)}%`}
    </text>
  )
}

export function InspeksiChart({ data, isLoading }: InspeksiChartProps) {
  // Mock data for demo
  const mockData = {
    safe: 156,
    unsafe: 42,
    pending: 18,
  }

  const chartData = data || mockData
  const total = chartData.safe + chartData.unsafe + (chartData.pending || 0)

  const pieData = [
    { name: 'Aman', value: chartData.safe, fill: COLORS.safe, total },
    { name: 'Tidak Aman', value: chartData.unsafe, fill: COLORS.unsafe, total },
    ...(chartData.pending
      ? [{ name: 'Pending', value: chartData.pending, fill: COLORS.pending, total }]
      : []),
  ]

  if (isLoading) {
    return (
      <Card>
        <CardHeader>
          <Skeleton className="h-6 w-48" />
          <Skeleton className="h-4 w-64 mt-2" />
        </CardHeader>
        <CardContent>
          <Skeleton className="h-[300px] w-full rounded-full mx-auto max-w-[300px]" />
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="overflow-hidden">
      <CardHeader className="bg-gradient-to-r from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30 border-b border-slate-100 dark:border-slate-700/50">
        <CardTitle className="flex items-center gap-2">
          <div className="h-2 w-2 rounded-full bg-gradient-to-r from-emerald-500 to-teal-500" />
          Status Inspeksi
        </CardTitle>
        <CardDescription>
          Distribusi hasil inspeksi keselamatan
        </CardDescription>
      </CardHeader>
      <CardContent className="pt-6">
        <ResponsiveContainer width="100%" height={300}>
          <PieChart>
            <Pie
              data={pieData}
              cx="50%"
              cy="50%"
              labelLine={false}
              label={renderCustomLabel}
              outerRadius={110}
              innerRadius={60}
              paddingAngle={3}
              dataKey="value"
              strokeWidth={0}
            >
              {pieData.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={entry.fill} />
              ))}
            </Pie>
            <Tooltip content={<CustomTooltip />} />
            <Legend
              verticalAlign="bottom"
              height={36}
              formatter={(value) => (
                <span className="text-sm text-slate-600 dark:text-slate-400">{value}</span>
              )}
            />
          </PieChart>
        </ResponsiveContainer>
        
        {/* Stats summary */}
        <div className="grid grid-cols-3 gap-4 mt-4 pt-4 border-t border-slate-100 dark:border-slate-700/50">
          <div className="text-center">
            <p className="text-2xl font-bold text-emerald-500">{chartData.safe}</p>
            <p className="text-xs text-slate-500">Aman</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-rose-500">{chartData.unsafe}</p>
            <p className="text-xs text-slate-500">Tidak Aman</p>
          </div>
          {chartData.pending !== undefined && (
            <div className="text-center">
              <p className="text-2xl font-bold text-amber-500">{chartData.pending}</p>
              <p className="text-xs text-slate-500">Pending</p>
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  )
}

export default InspeksiChart

