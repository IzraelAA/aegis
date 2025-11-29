export * from './user'
export * from './inspeksi'
export * from './incident'
export * from './permit'

export interface ApiResponse<T> {
  success: boolean
  data: T
  message?: string
}

export interface PaginatedResponse<T> {
  success: boolean
  data: T[]
  meta: {
    total: number
    page: number
    perPage: number
    totalPages: number
  }
}

export interface DashboardStats {
  totalInspections: number
  totalIncidents: number
  totalPermits: number
  safeInspections: number
  unsafeInspections: number
  pendingPermits: number
  openIncidents: number
}

