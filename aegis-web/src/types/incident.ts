export type IncidentSeverity = 'minor' | 'major' | 'near-miss'
export type IncidentStatus = 'open' | 'investigating' | 'closed'

export interface Incident {
  id: string
  title: string
  description: string
  location: string
  severity: IncidentSeverity
  status: IncidentStatus
  date: string
  time?: string
  photos?: string[]
  witnesses?: string[]
  injuredPersons?: number
  rootCause?: string
  correctiveActions?: string
  preventiveMeasures?: string
  reporter: {
    id: string
    name: string
  }
  investigator?: {
    id: string
    name: string
  }
  department?: string
  createdAt: string
  updatedAt: string
}

export interface CreateIncidentPayload {
  title: string
  description: string
  location: string
  severity: IncidentSeverity
  date: string
  time?: string
  witnesses?: string[]
  injuredPersons?: number
  department?: string
}

export interface UpdateIncidentPayload {
  title?: string
  description?: string
  status?: IncidentStatus
  rootCause?: string
  correctiveActions?: string
  preventiveMeasures?: string
}

export interface IncidentStats {
  total: number
  minor: number
  major: number
  nearMiss: number
  open: number
  investigating: number
  closed: number
}

export interface IncidentChartData {
  month: string
  minor: number
  major: number
  nearMiss: number
}

