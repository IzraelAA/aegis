import Cookies from 'js-cookie'
import { AuthUser, LoginCredentials, AuthResponse } from '@/types'
import api from './axios'

export async function login(credentials: LoginCredentials): Promise<AuthResponse> {
  const response = await api.post<{ data: AuthResponse }>('/auth/login', credentials)
  const { accessToken, refreshToken, user } = response.data.data

  // Store tokens in cookies
  Cookies.set('accessToken', accessToken, { 
    expires: 1, // 1 day
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax'
  })
  Cookies.set('refreshToken', refreshToken, { 
    expires: 7, // 7 days
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax'
  })

  // Store user info
  localStorage.setItem('user', JSON.stringify(user))

  return response.data.data
}

export async function logout(): Promise<void> {
  try {
    await api.post('/auth/logout')
  } catch (error) {
    console.error('Logout error:', error)
  } finally {
    Cookies.remove('accessToken')
    Cookies.remove('refreshToken')
    localStorage.removeItem('user')
    window.location.href = '/login'
  }
}

export function getStoredUser(): AuthUser | null {
  if (typeof window === 'undefined') return null
  
  const userStr = localStorage.getItem('user')
  if (!userStr) return null
  
  try {
    return JSON.parse(userStr) as AuthUser
  } catch {
    return null
  }
}

export function isAuthenticated(): boolean {
  return !!Cookies.get('accessToken')
}

export async function getCurrentUser(): Promise<AuthUser | null> {
  try {
    const response = await api.get<{ data: AuthUser }>('/auth/me')
    const user = response.data.data
    localStorage.setItem('user', JSON.stringify(user))
    return user
  } catch (error) {
    return null
  }
}

export function hasRole(user: AuthUser | null, roles: string[]): boolean {
  if (!user) return false
  return roles.includes(user.role)
}

export function canManageUsers(user: AuthUser | null): boolean {
  return hasRole(user, ['admin'])
}

export function canApprovePermits(user: AuthUser | null): boolean {
  return hasRole(user, ['admin', 'supervisor', 'safety_officer'])
}

export function canManageIncidents(user: AuthUser | null): boolean {
  return hasRole(user, ['admin', 'supervisor', 'safety_officer'])
}

