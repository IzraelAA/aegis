import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(date: string | Date): string {
  return new Date(date).toLocaleDateString('id-ID', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  })
}

export function formatDateTime(date: string | Date): string {
  return new Date(date).toLocaleString('id-ID', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

export function getStatusColor(status: string): string {
  const colors: Record<string, string> = {
    safe: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20',
    unsafe: 'bg-red-500/10 text-red-500 border-red-500/20',
    pending: 'bg-amber-500/10 text-amber-500 border-amber-500/20',
    approved: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20',
    rejected: 'bg-red-500/10 text-red-500 border-red-500/20',
    minor: 'bg-amber-500/10 text-amber-500 border-amber-500/20',
    major: 'bg-red-500/10 text-red-500 border-red-500/20',
    'near-miss': 'bg-blue-500/10 text-blue-500 border-blue-500/20',
    open: 'bg-amber-500/10 text-amber-500 border-amber-500/20',
    closed: 'bg-slate-500/10 text-slate-500 border-slate-500/20',
    investigating: 'bg-purple-500/10 text-purple-500 border-purple-500/20',
  }
  return colors[status.toLowerCase()] || 'bg-slate-500/10 text-slate-500 border-slate-500/20'
}

export function getRoleColor(role: string): string {
  const colors: Record<string, string> = {
    admin: 'bg-purple-500/10 text-purple-500 border-purple-500/20',
    supervisor: 'bg-blue-500/10 text-blue-500 border-blue-500/20',
    safety_officer: 'bg-emerald-500/10 text-emerald-500 border-emerald-500/20',
    worker: 'bg-slate-500/10 text-slate-500 border-slate-500/20',
  }
  return colors[role.toLowerCase()] || 'bg-slate-500/10 text-slate-500 border-slate-500/20'
}

