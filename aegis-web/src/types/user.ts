export type UserRole = 'admin' | 'supervisor' | 'safety_officer' | 'worker'

export interface User {
  id: string
  name: string
  email: string
  role: UserRole
  department?: string
  phone?: string
  avatar?: string
  isActive: boolean
  createdAt: string
  updatedAt: string
}

export interface CreateUserPayload {
  name: string
  email: string
  password: string
  role: UserRole
  department?: string
  phone?: string
}

export interface UpdateUserPayload {
  name?: string
  email?: string
  role?: UserRole
  department?: string
  phone?: string
  isActive?: boolean
}

export interface AuthUser {
  id: string
  name: string
  email: string
  role: UserRole
  avatar?: string
}

export interface LoginCredentials {
  email: string
  password: string
}

export interface AuthResponse {
  user: AuthUser
  accessToken: string
  refreshToken: string
}

