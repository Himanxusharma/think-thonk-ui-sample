'use client'

import { useEffect, useState } from 'react'
import { AlertCircle, ShieldAlert } from 'lucide-react'
import Link from 'next/link'
import AdminPanel from '@/components/admin/admin-panel'
import { isCurrentUserAdmin } from '@/lib/services/admin_service'

export default function AdminPage() {
  const [isAdmin, setIsAdmin] = useState<boolean | null>(null)

  useEffect(() => {
    // Check if user is admin
    const adminStatus = isCurrentUserAdmin()
    setIsAdmin(adminStatus)

    // If not admin, the UI will show error
    if (!adminStatus) {
      console.warn('[AdminPage] Access denied: User is not an admin')
    }
  }, [])

  // Loading state
  if (isAdmin === null) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    )
  }

  // Access denied
  if (!isAdmin) {
    return (
      <div className="max-w-md mx-auto py-12">
        <div className="bg-red-500/10 border border-red-500/20 rounded-lg p-6 text-center">
          <ShieldAlert className="w-12 h-12 text-red-500 mx-auto mb-4" />
          <h1 className="text-xl font-bold text-foreground mb-2">
            Access Denied
          </h1>
          <p className="text-sm text-muted-foreground mb-6">
            You do not have permission to access this page. Only administrators
            can create and manage content ideas.
          </p>
          <Link
            href="/"
            className="inline-block px-4 py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-colors text-sm font-medium"
          >
            Go Home
          </Link>
        </div>

        {/* Demo Info */}
        <div className="mt-6 bg-blue-500/10 border border-blue-500/20 rounded-lg p-4">
          <p className="text-xs text-blue-600 font-medium mb-2">Demo Information</p>
          <p className="text-xs text-muted-foreground">
            To test the admin features, set admin access in your browser console:
          </p>
          <code className="text-xs bg-background px-2 py-1 rounded block mt-2 text-foreground/70">
            localStorage.setItem('isAdmin', 'true')
          </code>
          <p className="text-xs text-muted-foreground mt-2">
            Then refresh the page to access the admin dashboard.
          </p>
        </div>
      </div>
    )
  }

  // Admin access granted
  return <AdminPanel />
}
