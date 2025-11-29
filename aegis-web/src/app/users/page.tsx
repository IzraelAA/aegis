'use client'

import { useState } from 'react'
import { DashboardLayout } from '@/components/dashboard-layout'
import { DataTable } from '@/components/data-table'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog'
import { useUserList, useCreateUser, useUpdateUser, useDeleteUser } from '@/hooks/useApi'
import { User, UserRole } from '@/types'
import { ColumnDef } from '@tanstack/react-table'
import { formatDate, getRoleColor } from '@/lib/utils'
import { toast } from '@/hooks/useToast'
import {
  Users,
  Plus,
  MoreHorizontal,
  Edit,
  Trash2,
  Mail,
  Phone,
  Building2,
  Shield,
  UserCheck,
  UserX,
} from 'lucide-react'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'

// Mock data for demo
const mockUsers: User[] = [
  {
    id: '1',
    name: 'Ahmad Rizki',
    email: 'ahmad.rizki@example.com',
    role: 'admin',
    department: 'IT',
    phone: '081234567890',
    isActive: true,
    createdAt: '2023-06-15T08:00:00Z',
    updatedAt: '2024-01-10T10:00:00Z',
  },
  {
    id: '2',
    name: 'Budi Santoso',
    email: 'budi.santoso@example.com',
    role: 'supervisor',
    department: 'Produksi',
    phone: '081234567891',
    isActive: true,
    createdAt: '2023-07-20T09:00:00Z',
    updatedAt: '2024-01-05T14:00:00Z',
  },
  {
    id: '3',
    name: 'Siti Rahayu',
    email: 'siti.rahayu@example.com',
    role: 'safety_officer',
    department: 'K3',
    phone: '081234567892',
    isActive: true,
    createdAt: '2023-08-10T11:00:00Z',
    updatedAt: '2024-01-08T09:00:00Z',
  },
  {
    id: '4',
    name: 'Dian Permata',
    email: 'dian.permata@example.com',
    role: 'worker',
    department: 'Maintenance',
    phone: '081234567893',
    isActive: true,
    createdAt: '2023-09-05T10:00:00Z',
    updatedAt: '2023-12-20T16:00:00Z',
  },
  {
    id: '5',
    name: 'Eko Prasetyo',
    email: 'eko.prasetyo@example.com',
    role: 'worker',
    department: 'Produksi',
    phone: '081234567894',
    isActive: false,
    createdAt: '2023-10-12T08:30:00Z',
    updatedAt: '2024-01-02T11:00:00Z',
  },
]

const roleLabels: Record<UserRole, string> = {
  admin: 'Administrator',
  supervisor: 'Supervisor',
  safety_officer: 'Safety Officer',
  worker: 'Pekerja',
}

const columns: ColumnDef<User>[] = [
  {
    accessorKey: 'name',
    header: 'Nama',
    cell: ({ row }) => {
      const user = row.original
      const initials = user.name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .toUpperCase()
        .slice(0, 2)
      return (
        <div className="flex items-center gap-3">
          <Avatar className="h-9 w-9">
            <AvatarImage src={user.avatar} alt={user.name} />
            <AvatarFallback className="bg-gradient-to-br from-teal-400 to-emerald-500 text-white text-xs">
              {initials}
            </AvatarFallback>
          </Avatar>
          <div>
            <p className="font-medium text-slate-900 dark:text-white">{user.name}</p>
            <p className="text-xs text-slate-500">{user.email}</p>
          </div>
        </div>
      )
    },
  },
  {
    accessorKey: 'role',
    header: 'Role',
    cell: ({ row }) => {
      const role = row.original.role
      return (
        <Badge className={`${getRoleColor(role)} w-fit`}>
          {roleLabels[role]}
        </Badge>
      )
    },
  },
  {
    accessorKey: 'department',
    header: 'Departemen',
    cell: ({ row }) => (
      <div className="flex items-center gap-2 text-slate-600 dark:text-slate-400">
        <Building2 className="h-4 w-4" />
        <span>{row.original.department || '-'}</span>
      </div>
    ),
  },
  {
    accessorKey: 'isActive',
    header: 'Status',
    cell: ({ row }) => {
      const isActive = row.original.isActive
      return (
        <Badge
          variant={isActive ? 'success' : 'secondary'}
          className="flex items-center gap-1 w-fit"
        >
          {isActive ? (
            <>
              <UserCheck className="h-3.5 w-3.5" />
              Aktif
            </>
          ) : (
            <>
              <UserX className="h-3.5 w-3.5" />
              Nonaktif
            </>
          )}
        </Badge>
      )
    },
  },
  {
    accessorKey: 'createdAt',
    header: 'Bergabung',
    cell: ({ row }) => (
      <span className="text-slate-600 dark:text-slate-400">
        {formatDate(row.original.createdAt)}
      </span>
    ),
  },
  {
    id: 'actions',
    cell: ({ row }) => (
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="ghost" size="icon" className="h-8 w-8">
            <MoreHorizontal className="h-4 w-4" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
          <DropdownMenuLabel>Aksi</DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem>
            <Edit className="mr-2 h-4 w-4" />
            Edit
          </DropdownMenuItem>
          <DropdownMenuItem className="text-rose-600">
            <Trash2 className="mr-2 h-4 w-4" />
            Hapus
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    ),
  },
]

export default function UsersPage() {
  const [roleFilter, setRoleFilter] = useState<string>('all')
  const [showAddDialog, setShowAddDialog] = useState(false)
  const [newUser, setNewUser] = useState({
    name: '',
    email: '',
    password: '',
    role: 'worker' as UserRole,
    department: '',
    phone: '',
  })

  const { data, isLoading } = useUserList(
    roleFilter !== 'all' ? { role: roleFilter } : undefined
  )
  const createMutation = useCreateUser()

  // Use mock data if API fails
  const userData = data?.data || mockUsers
  const filteredData = roleFilter === 'all'
    ? userData
    : userData.filter(u => u.role === roleFilter)

  const handleCreateUser = async () => {
    if (!newUser.name || !newUser.email || !newUser.password) {
      toast({
        title: 'Error',
        description: 'Nama, email, dan password wajib diisi',
        variant: 'destructive',
      })
      return
    }

    try {
      await createMutation.mutateAsync(newUser)
      toast({
        title: 'Berhasil',
        description: 'Pengguna baru berhasil ditambahkan',
        variant: 'success',
      })
      setShowAddDialog(false)
      setNewUser({
        name: '',
        email: '',
        password: '',
        role: 'worker',
        department: '',
        phone: '',
      })
    } catch (error) {
      toast({
        title: 'Gagal',
        description: 'Terjadi kesalahan saat menambahkan pengguna',
        variant: 'destructive',
      })
    }
  }

  // Calculate stats
  const stats = {
    total: userData.length,
    admin: userData.filter(u => u.role === 'admin').length,
    supervisor: userData.filter(u => u.role === 'supervisor').length,
    safetyOfficer: userData.filter(u => u.role === 'safety_officer').length,
    worker: userData.filter(u => u.role === 'worker').length,
    active: userData.filter(u => u.isActive).length,
  }

  return (
    <DashboardLayout>
      <div className="space-y-6">
        {/* Page Header */}
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div>
            <h1 className="text-3xl font-bold text-slate-900 dark:text-white flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-purple-500 to-indigo-500 text-white">
                <Users className="h-5 w-5" />
              </div>
              Pengguna
            </h1>
            <p className="text-slate-500 dark:text-slate-400 mt-1">
              Kelola pengguna dan hak akses sistem
            </p>
          </div>
          <Dialog open={showAddDialog} onOpenChange={setShowAddDialog}>
            <DialogTrigger asChild>
              <Button className="bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 text-white shadow-lg shadow-purple-500/25">
                <Plus className="mr-2 h-4 w-4" />
                Tambah Pengguna
              </Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-md">
              <DialogHeader>
                <DialogTitle>Tambah Pengguna Baru</DialogTitle>
                <DialogDescription>
                  Masukkan data pengguna baru untuk ditambahkan ke sistem.
                </DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="name">Nama Lengkap</Label>
                  <Input
                    id="name"
                    value={newUser.name}
                    onChange={(e) => setNewUser({ ...newUser, name: e.target.value })}
                    placeholder="Masukkan nama lengkap"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="email">Email</Label>
                  <Input
                    id="email"
                    type="email"
                    value={newUser.email}
                    onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
                    placeholder="nama@example.com"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="password">Password</Label>
                  <Input
                    id="password"
                    type="password"
                    value={newUser.password}
                    onChange={(e) => setNewUser({ ...newUser, password: e.target.value })}
                    placeholder="Minimal 8 karakter"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="role">Role</Label>
                  <Select
                    value={newUser.role}
                    onValueChange={(value) => setNewUser({ ...newUser, role: value as UserRole })}
                  >
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="admin">Administrator</SelectItem>
                      <SelectItem value="supervisor">Supervisor</SelectItem>
                      <SelectItem value="safety_officer">Safety Officer</SelectItem>
                      <SelectItem value="worker">Pekerja</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="department">Departemen</Label>
                  <Input
                    id="department"
                    value={newUser.department}
                    onChange={(e) => setNewUser({ ...newUser, department: e.target.value })}
                    placeholder="Nama departemen"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="phone">No. Telepon</Label>
                  <Input
                    id="phone"
                    value={newUser.phone}
                    onChange={(e) => setNewUser({ ...newUser, phone: e.target.value })}
                    placeholder="08xxxxxxxxxx"
                  />
                </div>
              </div>
              <DialogFooter>
                <Button variant="outline" onClick={() => setShowAddDialog(false)}>
                  Batal
                </Button>
                <Button
                  onClick={handleCreateUser}
                  disabled={createMutation.isPending}
                  className="bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 text-white"
                >
                  {createMutation.isPending ? 'Menyimpan...' : 'Simpan'}
                </Button>
              </DialogFooter>
            </DialogContent>
          </Dialog>
        </div>

        {/* Stats Cards */}
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-6">
          <Card className="bg-gradient-to-br from-slate-50 to-white dark:from-slate-800/50 dark:to-slate-800/30">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Total</p>
                  <p className="text-3xl font-bold text-slate-900 dark:text-white">{stats.total}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-slate-100 dark:bg-slate-700">
                  <Users className="h-6 w-6 text-slate-600 dark:text-slate-300" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-purple-50 to-purple-50/50 dark:from-purple-900/20 dark:to-purple-900/10 border-purple-100 dark:border-purple-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Admin</p>
                  <p className="text-3xl font-bold text-purple-600 dark:text-purple-400">{stats.admin}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-purple-100 dark:bg-purple-800/50">
                  <Shield className="h-6 w-6 text-purple-600 dark:text-purple-400" />
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-blue-50 to-blue-50/50 dark:from-blue-900/20 dark:to-blue-900/10 border-blue-100 dark:border-blue-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Supervisor</p>
                  <p className="text-3xl font-bold text-blue-600 dark:text-blue-400">{stats.supervisor}</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-emerald-50 to-emerald-50/50 dark:from-emerald-900/20 dark:to-emerald-900/10 border-emerald-100 dark:border-emerald-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Safety Officer</p>
                  <p className="text-3xl font-bold text-emerald-600 dark:text-emerald-400">{stats.safetyOfficer}</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-slate-50 to-slate-50/50 dark:from-slate-900/20 dark:to-slate-900/10 border-slate-200 dark:border-slate-700">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Pekerja</p>
                  <p className="text-3xl font-bold text-slate-600 dark:text-slate-400">{stats.worker}</p>
                </div>
              </div>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-br from-green-50 to-green-50/50 dark:from-green-900/20 dark:to-green-900/10 border-green-100 dark:border-green-800">
            <CardContent className="pt-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-500">Aktif</p>
                  <p className="text-3xl font-bold text-green-600 dark:text-green-400">{stats.active}</p>
                </div>
                <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-green-100 dark:bg-green-800/50">
                  <UserCheck className="h-6 w-6 text-green-600 dark:text-green-400" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Table */}
        <Card>
          <CardHeader>
            <CardTitle>Daftar Pengguna</CardTitle>
            <CardDescription>
              Kelola pengguna sistem dan hak akses mereka
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center gap-4 mb-6">
              <Select value={roleFilter} onValueChange={setRoleFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter Role" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Semua Role</SelectItem>
                  <SelectItem value="admin">Administrator</SelectItem>
                  <SelectItem value="supervisor">Supervisor</SelectItem>
                  <SelectItem value="safety_officer">Safety Officer</SelectItem>
                  <SelectItem value="worker">Pekerja</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <DataTable
              columns={columns}
              data={filteredData}
              searchKey="name"
              searchPlaceholder="Cari pengguna..."
              isLoading={isLoading}
            />
          </CardContent>
        </Card>
      </div>
    </DashboardLayout>
  )
}

