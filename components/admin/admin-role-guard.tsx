'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import AuthService from '@/lib/services/auth_service'

interface AdminRoleGuardProps {
  children: React.ReactNode
}

export default function AdminRoleGuard({ children }: AdminRoleGuardProps) {
  const router = useRouter()
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Check if user is authenticated and is admin
    const user = AuthService.getCurrentUser()
    
    if (!user) {
      // Not logged in, redirect to auth
      router.push('/auth')
      return
    }

    if (user.role !== 'admin') {
      // Not admin, redirect to home
      router.push('/')
      return
    }

    // User is authorized
    setIsAuthorized(true)
    setIsLoading(false)
  }, [router])

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="space-y-4 text-center">
          <div className="w-8 h-8 rounded-full border-2 border-primary border-t-transparent animate-spin mx-auto"></div>
          <p className="text-sm text-muted-foreground">Loading...</p>
        </div>
      </div>
    )
  }

  if (!isAuthorized) {
    return null
  }

  return <>{children}</>
}
