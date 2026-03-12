'use client'

import { useState, useRef, useEffect } from 'react'
import { User, Bookmark, Settings, LogOut, ChevronRight, Zap } from 'lucide-react'
import Link from 'next/link'
import { isCurrentUserAdmin } from '@/lib/services/admin_service'

export default function ProfileMenu() {
  const [isOpen, setIsOpen] = useState(false)
  const [isAdmin, setIsAdmin] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsOpen(false)
      }
    }

    // Check if user is admin
    setIsAdmin(isCurrentUserAdmin())

    document.addEventListener('mousedown', handleClickOutside)
    return () => document.removeEventListener('mousedown', handleClickOutside)
  }, [])

  const menuItems = [
    { icon: User, label: 'Profile', href: '/profile' },
    { icon: Bookmark, label: 'Saved Articles', href: '/saved' },
    { icon: Settings, label: 'Settings', href: '/settings' },
  ]

  const adminItems = isAdmin
    ? [{ icon: Zap, label: 'Admin Dashboard', href: '/admin' }]
    : []

  const allItems = [...menuItems, ...adminItems]

  return (
    <div ref={menuRef} className="relative">
      {/* Profile Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="p-2 rounded-lg hover:bg-muted transition-colors group"
        aria-label="Profile menu"
        aria-expanded={isOpen}
      >
        <User className="w-5 h-5 group-hover:text-primary transition-colors" />
      </button>

      {/* Dropdown Menu */}
      {isOpen && (
        <div className="absolute right-0 mt-3 w-56 bg-card border border-border rounded-lg shadow-xl overflow-hidden z-50 animate-in fade-in slide-in-from-top-2 duration-200">
          {/* Header */}
          <div className="px-4 py-3 border-b border-border bg-muted/30">
            <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">
              Account
            </p>
          </div>

          {/* Menu Items */}
          <div className="py-1">
            {allItems.map((item, index) => {
              const Icon = item.icon
              const isAdminItem = item.href === '/admin'
              return (
                <Link
                  key={index}
                  href={item.href}
                  onClick={() => setIsOpen(false)}
                  className={`flex items-center justify-between px-4 py-3 transition-colors group text-sm ${
                    isAdminItem
                      ? 'bg-primary/5 hover:bg-primary/10 border-l-2 border-primary'
                      : 'hover:bg-muted'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className={`w-4 h-4 transition-colors ${
                      isAdminItem
                        ? 'text-primary group-hover:text-primary'
                        : 'text-muted-foreground group-hover:text-primary'
                    }`} />
                    <span className={`font-medium ${
                      isAdminItem
                        ? 'text-primary'
                        : 'text-foreground group-hover:text-foreground'
                    }`}>
                      {item.label}
                    </span>
                  </div>
                  <ChevronRight className="w-4 h-4 text-muted-foreground opacity-0 group-hover:opacity-100 transition-all" />
                </Link>
              )
            })}
          </div>

          {/* Divider */}
          <div className="border-t border-border" />

          {/* Logout */}
          <button
            onClick={() => {
              setIsOpen(false)
              window.location.href = '/auth'
            }}
            className="w-full flex items-center gap-3 px-4 py-3 hover:bg-red-500/5 transition-colors text-sm group text-red-500"
          >
            <LogOut className="w-4 h-4" />
            <span>Logout</span>
          </button>
        </div>
      )}
    </div>
  )
}
