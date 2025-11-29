'use client'

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend,
} from 'recharts'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { IncidentChartData } from '@/types'
import { Skeleton } from '@/components/ui/skeleton'

interface IncidentsChartProps {
  data?: IncidentChartData[]
  isLoading?: boolean
}

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white dark:bg-slate-800 p-4 rounded-lg shadow-lg border border-slate-200 dark:border-slate-700">
        <p className="font-semibold text-slate-900 dark:text-white mb-2">{label}</p>
        {payload.map((entry: any, index: number) => (
          <div key={index} className="flex items-center gap-2 text-sm">
            <div
              className="w-3 h-3 rounded-full"
              style={{ backgroundColor: entry.color }}
            />
            <span className="text-slate-600 dark:text-slate-400">{entry.name}:</span>
            <span className="font-medium text-slate-900 dark:text-white">{entry.value}</span>
          </div>
        ))}
      </div>
    )
  }
  return null
}

export function IncidentsChart({ data, isLoading }: IncidentsChartProps) {
  // Mock data for demo
  const mockData: IncidentChartData[] = [
    { month: 'Jan', minor: 12, major: 3, nearMiss: 8 },
    { month: 'Feb', minor: 8, major: 2, nearMiss: 15 },
    { month: 'Mar', minor: 15, major: 4, nearMiss: 12 },
    { month: 'Apr', minor: 10, major: 1, nearMiss: 18 },
    { month: 'Mei', minor: 7, major: 2, nearMiss: 10 },
    { month: 'Jun', minor: 11, major: 3, nearMiss: 14 },
    { month: 'Jul', minor: 9, major: 1, nearMiss: 9 },
    { month: 'Agu', minor: 13, major: 2, nearMiss: 11 },
    { month: 'Sep', minor: 6, major: 0, nearMiss: 16 },
    { month: 'Okt', minor: 10, major: 2, nearMiss: 13 },
    { month: 'Nov', minor: 8, major: 1, nearMiss: 7 },
    { month: 'Des', minor: 5, major: 1, nearMiss: 10 },
  ]

  const chartData = data || mockData

  if (isLoading) {
    return (
      <Card className="col-span-2">
        <CardHeader>
          <Skeleton className="h-6 w-48" />
          <Skeleton className="h-4 w-64 mt-2" />
        </CardHeader>
        <CardContent>
          <Skeleton className="h-[350px] w-full" />
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="col-span-2 overflow-hidden">
      <CardHeader className="bg-gradient-to-r from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30 border-b border-slate-100 dark:border-slate-700/50">
        <CardTitle className="flex items-center gap-2">
          <div className="h-2 w-2 rounded-full bg-gradient-to-r from-rose-500 to-amber-500" />
          Statistik Insiden Bulanan
        </CardTitle>
        <CardDescription>
          Grafik jumlah insiden berdasarkan tingkat keparahan
        </CardDescription>
      </CardHeader>
      <CardContent className="pt-6">
        <ResponsiveContainer width="100%" height={350}>
          <BarChart data={chartData} barGap={8}>
            <CartesianGrid strokeDasharray="3 3" className="stroke-slate-200 dark:stroke-slate-700" vertical={false} />
            <XAxis
              dataKey="month"
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#64748b', fontSize: 12 }}
            />
            <YAxis
              axisLine={false}
              tickLine={false}
              tick={{ fill: '#64748b', fontSize: 12 }}
            />
            <Tooltip content={<CustomTooltip />} />
            <Legend
              wrapperStyle={{ paddingTop: 20 }}
              formatter={(value) => (
                <span className="text-sm text-slate-600 dark:text-slate-400">{value}</span>
              )}
            />
            <Bar
              dataKey="minor"
              name="Minor"
              fill="#f59e0b"
              radius={[4, 4, 0, 0]}
              maxBarSize={40}
            />
            <Bar
              dataKey="major"
              name="Major"
              fill="#ef4444"
              radius={[4, 4, 0, 0]}
              maxBarSize={40}
            />
            <Bar
              dataKey="nearMiss"
              name="Near Miss"
              fill="#3b82f6"
              radius={[4, 4, 0, 0]}
              maxBarSize={40}
            />
          </BarChart>
        </ResponsiveContainer>
      </CardContent>
    </Card>
  )
}

export default IncidentsChart

