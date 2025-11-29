export type PermitType = 'hot_work' | 'confined_space' | 'height_work' | 'electrical' | 'excavation' | 'general'
export type PermitStatus = 'pending' | 'approved' | 'rejected' | 'expired' | 'closed'

export interface Permit {
  id: string
  permitNumber: string
  type: PermitType
  title: string
  description: string
  location: string
  status: PermitStatus
  startDate: string
  endDate: string
  hazards?: string[]
  precautions?: string[]
  equipment?: string[]
  requester: {
    id: string
    name: string
  }
  approver?: {
    id: string
    name: string
  }
  workers?: {
    id: string
    name: string
  }[]
  department?: string
  rejectionReason?: string
  approvedAt?: string
  rejectedAt?: string
  createdAt: string
  updatedAt: string
}

export interface CreatePermitPayload {
  type: PermitType
  title: string
  description: string
  location: string
  startDate: string
  endDate: string
  hazards?: string[]
  precautions?: string[]
  equipment?: string[]
  department?: string
}

export interface UpdatePermitPayload {
  title?: string
  description?: string
  location?: string
  startDate?: string
  endDate?: string
  hazards?: string[]
  precautions?: string[]
  equipment?: string[]
}

export interface ApprovePermitPayload {
  approved: boolean
  rejectionReason?: string
}

export interface PermitStats {
  total: number
  pending: number
  approved: number
  rejected: number
  expired: number
}

