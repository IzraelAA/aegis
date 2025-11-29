export type InspeksiStatus = 'safe' | 'unsafe' | 'pending'

export interface Inspeksi {
  id: string
  title: string
  description: string
  location: string
  status: InspeksiStatus
  photo?: string
  photos?: string[]
  findings?: string
  recommendations?: string
  inspector: {
    id: string
    name: string
  }
  department?: string
  area?: string
  createdAt: string
  updatedAt: string
}

export interface CreateInspeksiPayload {
  title: string
  description: string
  location: string
  status: InspeksiStatus
  findings?: string
  recommendations?: string
  department?: string
  area?: string
}

export interface UpdateInspeksiPayload {
  title?: string
  description?: string
  location?: string
  status?: InspeksiStatus
  findings?: string
  recommendations?: string
}

export interface InspeksiStats {
  total: number
  safe: number
  unsafe: number
  pending: number
}

export interface InspeksiChartData {
  month: string
  safe: number
  unsafe: number
}

