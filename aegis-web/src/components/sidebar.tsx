'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { cn } from '@/lib/utils'
import {
  LayoutDashboard,
  ClipboardCheck,
  AlertTriangle,
  FileCheck,
  Users,
  Shield,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react'
import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'

const navigation = [
  {
    name: 'Dashboard',
    href: '/',
    icon: LayoutDashboard,
  },
  {
    name: 'Inspeksi',
    href: '/inspeksi',
    icon: ClipboardCheck,
  },
  {
    name: 'Insiden',
    href: '/incident',
    icon: AlertTriangle,
  },
  {
    name: 'Permit to Work',
    href: '/permit',
    icon: FileCheck,
  },
  {
    name: 'Pengguna',
    href: '/users',
    icon: Users,
  },
]

export function Sidebar() {
  const pathname = usePathname()
  const [collapsed, setCollapsed] = useState(false)

  return (
    <aside
      className={cn(
        'fixed left-0 top-0 z-40 h-screen bg-gradient-to-b from-slate-900 via-slate-900 to-slate-950 border-r border-slate-800/50 transition-all duration-300 ease-in-out',
        collapsed ? 'w-[70px]' : 'w-64'
      )}
    >
      {/* Logo */}
      <div className="flex h-16 items-center justify-between px-4 border-b border-slate-800/50">
        <Link href="/" className="flex items-center gap-3">
          <div className="relative">
            <div className="absolute inset-0 bg-teal-500 blur-lg opacity-50 rounded-full"></div>
            <div className="relative flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-teal-400 to-emerald-500 shadow-lg">
              <Shield className="h-5 w-5 text-white" />
            </div>
          </div>
          {!collapsed && (
            <div className="flex flex-col">
              <span className="text-lg font-bold text-white tracking-tight">
                AEGIS
              </span>
              <span className="text-[10px] text-slate-400 -mt-1 tracking-widest">
                K3 SYSTEM
              </span>
            </div>
          )}
        </Link>
        <Button
          variant="ghost"
          size="icon"
          className="h-8 w-8 text-slate-400 hover:text-white hover:bg-slate-800"
          onClick={() => setCollapsed(!collapsed)}
        >
          {collapsed ? (
            <ChevronRight className="h-4 w-4" />
          ) : (
            <ChevronLeft className="h-4 w-4" />
          )}
        </Button>
      </div>

      {/* Navigation */}
      <nav className="flex flex-col gap-1 p-3 mt-2">
        {navigation.map((item, index) => {
          const isActive = pathname === item.href || pathname.startsWith(`${item.href}/`)
          const Icon = item.icon

          return (
            <Link
              key={item.href}
              href={item.href}
              style={{ animationDelay: `${index * 50}ms` }}
              className={cn(
                'group flex items-center gap-3 rounded-xl px-3 py-2.5 text-sm font-medium transition-all duration-200 animate-slide-in-left',
                isActive
                  ? 'bg-gradient-to-r from-teal-500/20 to-emerald-500/10 text-teal-400 shadow-lg shadow-teal-500/10'
                  : 'text-slate-400 hover:bg-slate-800/50 hover:text-white',
                collapsed && 'justify-center px-2'
              )}
            >
              <div
                className={cn(
                  'flex h-8 w-8 items-center justify-center rounded-lg transition-all duration-200',
                  isActive
                    ? 'bg-teal-500/20 text-teal-400'
                    : 'text-slate-500 group-hover:bg-slate-700/50 group-hover:text-white'
                )}
              >
                <Icon className="h-[18px] w-[18px]" />
              </div>
              {!collapsed && (
                <span className="truncate">{item.name}</span>
              )}
              {isActive && !collapsed && (
                <div className="ml-auto h-2 w-2 rounded-full bg-teal-400 shadow-lg shadow-teal-400/50" />
              )}
            </Link>
          )
        })}
      </nav>

      {/* Footer */}
      {!collapsed && (
        <div className="absolute bottom-0 left-0 right-0 p-4">
          <Separator className="mb-4 bg-slate-800/50" />
          <div className="rounded-xl bg-gradient-to-br from-slate-800/50 to-slate-800/30 p-4 border border-slate-700/50">
            <div className="flex items-center gap-3 mb-2">
              <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-amber-500/20">
                <AlertTriangle className="h-4 w-4 text-amber-400" />
              </div>
              <span className="text-sm font-medium text-white">Safety First</span>
            </div>
            <p className="text-xs text-slate-400 leading-relaxed">
              Utamakan keselamatan kerja. Laporkan kondisi tidak aman segera.
            </p>
          </div>
        </div>
      )}
    </aside>
  )
}

export default Sidebar

