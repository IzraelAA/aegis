'use client'

import { useQuery, useMutation, useQueryClient, UseQueryOptions, UseMutationOptions } from '@tanstack/react-query'
import api from '@/lib/axios'
import { 
  Inspeksi, 
  Incident, 
  Permit, 
  User,
  DashboardStats,
  InspeksiStats,
  IncidentStats,
  PermitStats,
  InspeksiChartData,
  IncidentChartData,
  CreateInspeksiPayload,
  UpdateInspeksiPayload,
  CreateIncidentPayload,
  UpdateIncidentPayload,
  CreatePermitPayload,
  UpdatePermitPayload,
  ApprovePermitPayload,
  CreateUserPayload,
  UpdateUserPayload,
} from '@/types'

// ============ Dashboard ============
export function useDashboardStats() {
  return useQuery({
    queryKey: ['dashboard', 'stats'],
    queryFn: async () => {
      const response = await api.get<{ data: DashboardStats }>('/dashboard/stats')
      return response.data.data
    },
  })
}

export function useIncidentChartData() {
  return useQuery({
    queryKey: ['dashboard', 'incidents-chart'],
    queryFn: async () => {
      const response = await api.get<{ data: IncidentChartData[] }>('/dashboard/incidents-chart')
      return response.data.data
    },
  })
}

export function useInspeksiChartData() {
  return useQuery({
    queryKey: ['dashboard', 'inspeksi-chart'],
    queryFn: async () => {
      const response = await api.get<{ data: InspeksiChartData[] }>('/dashboard/inspeksi-chart')
      return response.data.data
    },
  })
}

// ============ Inspeksi ============
export function useInspeksiList(params?: { status?: string; page?: number; limit?: number }) {
  return useQuery({
    queryKey: ['inspeksi', 'list', params],
    queryFn: async () => {
      const response = await api.get<{ data: Inspeksi[]; meta: { total: number; page: number; totalPages: number } }>('/inspeksi', { params })
      return response.data
    },
  })
}

export function useInspeksiDetail(id: string) {
  return useQuery({
    queryKey: ['inspeksi', 'detail', id],
    queryFn: async () => {
      const response = await api.get<{ data: Inspeksi }>(`/inspeksi/${id}`)
      return response.data.data
    },
    enabled: !!id,
  })
}

export function useInspeksiStats() {
  return useQuery({
    queryKey: ['inspeksi', 'stats'],
    queryFn: async () => {
      const response = await api.get<{ data: InspeksiStats }>('/inspeksi/stats')
      return response.data.data
    },
  })
}

export function useCreateInspeksi() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (data: CreateInspeksiPayload) => {
      const response = await api.post<{ data: Inspeksi }>('/inspeksi', data)
      return response.data.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['inspeksi'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useUpdateInspeksi() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: UpdateInspeksiPayload }) => {
      const response = await api.patch<{ data: Inspeksi }>(`/inspeksi/${id}`, data)
      return response.data.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['inspeksi'] })
      queryClient.invalidateQueries({ queryKey: ['inspeksi', 'detail', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useDeleteInspeksi() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/inspeksi/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['inspeksi'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

// ============ Incidents ============
export function useIncidentList(params?: { severity?: string; status?: string; page?: number; limit?: number }) {
  return useQuery({
    queryKey: ['incident', 'list', params],
    queryFn: async () => {
      const response = await api.get<{ data: Incident[]; meta: { total: number; page: number; totalPages: number } }>('/incidents', { params })
      return response.data
    },
  })
}

export function useIncidentDetail(id: string) {
  return useQuery({
    queryKey: ['incident', 'detail', id],
    queryFn: async () => {
      const response = await api.get<{ data: Incident }>(`/incidents/${id}`)
      return response.data.data
    },
    enabled: !!id,
  })
}

export function useIncidentStats() {
  return useQuery({
    queryKey: ['incident', 'stats'],
    queryFn: async () => {
      const response = await api.get<{ data: IncidentStats }>('/incidents/stats')
      return response.data.data
    },
  })
}

export function useCreateIncident() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (data: CreateIncidentPayload) => {
      const response = await api.post<{ data: Incident }>('/incidents', data)
      return response.data.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['incident'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useUpdateIncident() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: UpdateIncidentPayload }) => {
      const response = await api.patch<{ data: Incident }>(`/incidents/${id}`, data)
      return response.data.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['incident'] })
      queryClient.invalidateQueries({ queryKey: ['incident', 'detail', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useDeleteIncident() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/incidents/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['incident'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

// ============ Permits ============
export function usePermitList(params?: { type?: string; status?: string; page?: number; limit?: number }) {
  return useQuery({
    queryKey: ['permit', 'list', params],
    queryFn: async () => {
      const response = await api.get<{ data: Permit[]; meta: { total: number; page: number; totalPages: number } }>('/permits', { params })
      return response.data
    },
  })
}

export function usePermitDetail(id: string) {
  return useQuery({
    queryKey: ['permit', 'detail', id],
    queryFn: async () => {
      const response = await api.get<{ data: Permit }>(`/permits/${id}`)
      return response.data.data
    },
    enabled: !!id,
  })
}

export function usePermitStats() {
  return useQuery({
    queryKey: ['permit', 'stats'],
    queryFn: async () => {
      const response = await api.get<{ data: PermitStats }>('/permits/stats')
      return response.data.data
    },
  })
}

export function useCreatePermit() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (data: CreatePermitPayload) => {
      const response = await api.post<{ data: Permit }>('/permits', data)
      return response.data.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['permit'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useUpdatePermit() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: UpdatePermitPayload }) => {
      const response = await api.patch<{ data: Permit }>(`/permits/${id}`, data)
      return response.data.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['permit'] })
      queryClient.invalidateQueries({ queryKey: ['permit', 'detail', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useApprovePermit() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: ApprovePermitPayload }) => {
      const response = await api.post<{ data: Permit }>(`/permits/${id}/approve`, data)
      return response.data.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['permit'] })
      queryClient.invalidateQueries({ queryKey: ['permit', 'detail', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

export function useDeletePermit() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/permits/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['permit'] })
      queryClient.invalidateQueries({ queryKey: ['dashboard'] })
    },
  })
}

// ============ Users ============
export function useUserList(params?: { role?: string; page?: number; limit?: number }) {
  return useQuery({
    queryKey: ['users', 'list', params],
    queryFn: async () => {
      const response = await api.get<{ data: User[]; meta: { total: number; page: number; totalPages: number } }>('/users', { params })
      return response.data
    },
  })
}

export function useUserDetail(id: string) {
  return useQuery({
    queryKey: ['users', 'detail', id],
    queryFn: async () => {
      const response = await api.get<{ data: User }>(`/users/${id}`)
      return response.data.data
    },
    enabled: !!id,
  })
}

export function useCreateUser() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (data: CreateUserPayload) => {
      const response = await api.post<{ data: User }>('/users', data)
      return response.data.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
  })
}

export function useUpdateUser() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, data }: { id: string; data: UpdateUserPayload }) => {
      const response = await api.patch<{ data: User }>(`/users/${id}`, data)
      return response.data.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      queryClient.invalidateQueries({ queryKey: ['users', 'detail', variables.id] })
    },
  })
}

export function useDeleteUser() {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      await api.delete(`/users/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    },
  })
}

