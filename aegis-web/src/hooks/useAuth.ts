'use client'

import { useState, useEffect, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { AuthUser, LoginCredentials } from '@/types'
import { login as loginApi, logout as logoutApi, getStoredUser, getCurrentUser, isAuthenticated } from '@/lib/auth'

export function useAuth() {
  const [user, setUser] = useState<AuthUser | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const initAuth = async () => {
      if (!isAuthenticated()) {
        setIsLoading(false)
        return
      }

      // First, try to get user from localStorage
      const storedUser = getStoredUser()
      if (storedUser) {
        setUser(storedUser)
      }

      // Then validate with server
      try {
        const currentUser = await getCurrentUser()
        if (currentUser) {
          setUser(currentUser)
        } else if (!storedUser) {
          // No user data available
          router.push('/login')
        }
      } catch (error) {
        console.error('Auth initialization error:', error)
      } finally {
        setIsLoading(false)
      }
    }

    initAuth()
  }, [router])

  const login = useCallback(async (credentials: LoginCredentials) => {
    setIsLoading(true)
    try {
      const response = await loginApi(credentials)
      setUser(response.user)
      router.push('/')
      return response
    } finally {
      setIsLoading(false)
    }
  }, [router])

  const logout = useCallback(async () => {
    setIsLoading(true)
    try {
      await logoutApi()
      setUser(null)
    } finally {
      setIsLoading(false)
    }
  }, [])

  const refreshUser = useCallback(async () => {
    const currentUser = await getCurrentUser()
    if (currentUser) {
      setUser(currentUser)
    }
  }, [])

  return {
    user,
    isLoading,
    isAuthenticated: !!user,
    login,
    logout,
    refreshUser,
  }
}

export default useAuth

